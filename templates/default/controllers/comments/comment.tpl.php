<?php // Шаблон одного комментария // ?>

<?php
	$dim_negative = !empty($this->controller->options['dim_negative']);
	$is_guests_allowed = !empty($this->controller->options['is_guests']);
    $is_can_add = ($user->is_logged && cmsUser::isAllowed('comments', 'add')) || (!$user->is_logged && $is_guests_allowed);
    $is_highlight_new = isset($is_highlight_new) ? $is_highlight_new : false;
    if (!isset($is_can_rate)) { $is_can_rate = false; }
    $limit_nesting =  $this->controller->options['limit_nesting'];
?>

<?php foreach($comments as $entry){

    $no_approved_class = $entry['is_approved'] ? '' : 'no_approved';

    if (!isset($is_levels)){ $is_levels = true; }
    if (!isset($is_controls)){ $is_controls = true; }
    if (!isset($is_show_target)){ $is_show_target = false; }

    if ($is_show_target){
        $target_url = rel_to_href($entry['target_url']) . "#comment_{$entry['id']}";
    }

    if ($is_controls){
        $is_can_edit = cmsUser::isAllowed('comments', 'edit', 'all') || (cmsUser::isAllowed('comments', 'edit', 'own') && $entry['user']['id'] == $user->id);
        $is_can_delete = cmsUser::isAllowed('comments', 'delete', 'all') || (cmsUser::isAllowed('comments', 'delete', 'own') && $entry['user']['id'] == $user->id);
    }

    $is_selected = $is_highlight_new && ((int)strtotime($entry['date_pub']) > (int)strtotime($user->date_log));

?>

<div id="comment_<?php echo $entry['id']; ?>" class="comment<?php if($is_selected){ ?> selected-comment<?php } ?><?php if($target_user_id == $entry['user_id']){ ?> is_topic_starter<?php } ?>" <?php if ($is_levels) { ?>style="margin-left: <?php if ($entry['level'] <= $limit_nesting) { echo ($entry['level']-1)*30; } else { echo ($limit_nesting-1)*30; } ?>px" data-level="<?php echo $entry['level']; ?>"<?php } ?>>
    <?php if($entry['is_deleted']){ ?>
        <span class="deleted"><?php echo LANG_COMMENT_DELETED; ?></span>
        <span class="nav">
            <?php if ($entry['parent_id']){ ?>
                <a href="#up" class="scroll-up" onclick="return icms.comments.up(<?php echo $entry['parent_id']; ?>, <?php echo $entry['id']; ?>)" title="<?php html( LANG_COMMENT_SHOW_PARENT ); ?>">&uarr;</a>
            <?php } ?>
            <a href="#down" class="scroll-down" onclick="return icms.comments.down(this)" title="<?php echo html( LANG_COMMENT_SHOW_CHILD ); ?>">&darr;</a>
        </span>
    <?php } ?>
    <?php if(!$entry['is_deleted']){ ?>
    <div class="info">
        <div class="name">
			<?php if ($entry['user_id']) { ?>
				<a class="user" href="<?php echo href_to('users', $entry['user']['id']); ?>"><?php echo $entry['user']['nickname']; ?></a>
			<?php } else { ?>
				<span class="guest_name user"><?php echo $entry['author_name']; ?></span>
				<?php if ($user->is_admin && !empty($entry['author_url'])) { ?>
					<span class="guest_ip">
						[<?php echo $entry['author_url']; ?>]
					</span>
				<?php } ?>
			<?php } ?>
            <?php if($is_show_target){ ?>
                &rarr;
                <a class="subject" href="<?php echo $target_url; ?>"><?php html($entry['target_title']); ?></a>
            <?php } ?>
        </div>
        <div class="date">
            <span class="<?php echo $no_approved_class; ?>"><?php echo html_date_time($entry['date_pub']); ?></span>
            <?php if ($no_approved_class){ ?>
                <span class="hide_approved"><?php echo html_bool_span(LANG_CONTENT_NOT_APPROVED, false); ?></span>
            <?php } ?>
        </div>
        <?php if ($is_controls){ ?>
            <div class="nav">
                <a href="#comment_<?php echo $entry['id']; ?>" name="comment_<?php echo $entry['id']; ?>" title="<?php html( LANG_COMMENT_ANCHOR ); ?>">#</a>
                <?php if ($entry['parent_id']){ ?>
                    <a href="#up" class="scroll-up" onclick="return icms.comments.up(<?php echo $entry['parent_id']; ?>, <?php echo $entry['id']; ?>)" title="<?php html( LANG_COMMENT_SHOW_PARENT ); ?>">&uarr;</a>
                <?php } ?>
                <a href="#down" class="scroll-down" onclick="return icms.comments.down(this)" title="<?php echo html( LANG_COMMENT_SHOW_CHILD ); ?>">&darr;</a>
            </div>
            <div class="rating <?php echo $no_approved_class; ?>">
                <span class="value <?php echo html_signed_class($entry['rating']); ?>"><?php echo $entry['rating'] ? html_signed_num($entry['rating']) : ''; ?></span>
                <?php if ($is_can_rate && ($entry['user_id'] != $user->id) && !$entry['is_rated']){ ?>
                    <div class="buttons">
                        <a href="#rate-up" class="rate-up" title="<?php echo html( LANG_COMMENT_RATE_UP ); ?>" data-id="<?php echo $entry['id']; ?>"></a>
                        <a href="#rate-down" class="rate-down" title="<?php echo html( LANG_COMMENT_RATE_DOWN ); ?>" data-id="<?php echo $entry['id']; ?>"></a>
                    </div>
                <?php } ?>
            </div>
        <?php } ?>
    </div>
    <div class="body">
        <div <?php if (!empty($entry['user']['is_online'])){ ?>class="avatar comment_user_online" title="<?php echo LANG_ONLINE; ?>"<?php } else { ?> class="avatar"<?php } ?>>
            <a href="<?php echo href_to('users', $entry['user']['id']); ?>">
                <?php echo html_avatar_image($entry['user']['avatar'], 'micro', $entry['user']['nickname']); ?>
            </a>
        </div>
        <div class="content">
            <div class="text<?php if($dim_negative && $entry['rating'] < 0){ ?> bad<?php echo ($entry['rating'] < -6 ? 6 : abs($entry['rating'])) ?> bad<?php } ?>">
                <?php echo $entry['content_html']; ?>
            </div>
            <?php if ($is_controls){ ?>
                <div class="links">
                    <?php if ($no_approved_class){ ?>
                        <a href="#approve" class="approve hide_approved" onclick="return icms.comments.approve(<?php echo $entry['id']; ?>)"><?php echo LANG_COMMENTS_APPROVE; ?></a>
                    <?php } ?>
                    <?php if ($is_can_add){ ?>
                        <a href="#reply" class="reply <?php echo $no_approved_class; ?>" onclick="return icms.comments.add(<?php echo $entry['id']; ?>)"><?php echo LANG_REPLY; ?></a>
                    <?php } ?>
                    <?php if ($is_can_edit){ ?>
                        <a href="#edit" class="edit" onclick="return icms.comments.edit(<?php echo $entry['id']; ?>)"><?php echo LANG_EDIT; ?></a>
                    <?php } ?>
                    <?php if ($is_can_delete){ ?>
                        <a href="#delete" class="delete" onclick="return icms.comments.remove(<?php echo $entry['id']; ?>)"><?php echo LANG_DELETE; ?></a>
                    <?php } ?>
                </div>
            <?php } ?>
        </div>
    </div>
    <?php } ?>
</div>

<?php } ?>