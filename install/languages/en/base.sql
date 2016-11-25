DROP TABLE IF EXISTS `{#}activity`;
CREATE TABLE `{#}activity` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `group_id` int(11) unsigned DEFAULT NULL,
  `subject_title` varchar(140) DEFAULT NULL,
  `subject_id` int(11) unsigned DEFAULT NULL,
  `subject_url` varchar(250) DEFAULT NULL,
  `reply_url` varchar(250) DEFAULT NULL,
  `images` text,
  `images_count` int(11) unsigned DEFAULT NULL,
  `date_pub` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_private` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_parent_hidden` tinyint(1) unsigned DEFAULT NULL,
  `is_pub` tinyint(1) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `type_id` (`type_id`),
  KEY `user_id` (`user_id`),
  KEY `date_pub` (`date_pub`),
  KEY `is_private` (`is_private`),
  KEY `group_id` (`group_id`),
  KEY `is_parent_hidden` (`is_parent_hidden`),
  KEY `is_pub` (`is_pub`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}activity_types`;
CREATE TABLE `{#}activity_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `is_enabled` tinyint(1) unsigned DEFAULT '1',
  `controller` varchar(32) NOT NULL,
  `name` varchar(32) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `is_enabled` (`is_enabled`),
  KEY `controller` (`controller`),
  KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}activity_types` (`id`, `is_enabled`, `controller`, `name`, `title`, `description`) VALUES
(2, 1, 'comments', 'vote.comment', 'Rating comments', 'evaluate a comment on the %s page'),
(7, 1, 'users', 'friendship', 'Friendship', 'and %s became friends'),
(8, 1, 'users', 'signup', 'New users', 'registered. Welcome!'),
(10, 1, 'groups', 'join', 'Group joining', 'joined the group %s'),
(11, 1, 'groups', 'leave', 'Group leaving', 'left the group %s'),
(12, 1, 'users', 'status', 'Status changing', '&rarr; %s'),
(18, 1, 'photos', 'add.photos', 'Photo uploading', 'uploaded photos to the album %s'),
(19, 1, 'users', 'avatar', 'Avatar changing', 'changed avatar'),
(20, 1, 'content', 'add.pages', 'Adding pages', 'added the page %s');

DROP TABLE IF EXISTS `{#}comments`;
CREATE TABLE `{#}comments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) unsigned DEFAULT NULL COMMENT 'Parent comment ID',
  `level` tinyint(4) unsigned DEFAULT NULL COMMENT '',
  `ordering` int(11) unsigned DEFAULT NULL COMMENT 'Order number in the tree',
  `user_id` int(11) unsigned DEFAULT NULL COMMENT 'Author ID',
  `date_pub` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Publication date',
  `target_controller` varchar(32) DEFAULT NULL COMMENT 'Commented content controller',
  `target_subject` varchar(32) DEFAULT NULL COMMENT 'Commented object',
  `target_id` int(11) unsigned DEFAULT NULL COMMENT 'Commented object ID',
  `target_url` varchar(250) DEFAULT NULL COMMENT 'Commented object URL',
  `target_title` varchar(100) DEFAULT NULL COMMENT 'Commented object title',
  `author_name` varchar(100) DEFAULT NULL COMMENT 'Author (guest) name',
  `author_email` varchar(100) DEFAULT NULL COMMENT 'Author (guest) E-mail',
  `author_url` varchar(15) DEFAULT NULL COMMENT 'Author ip',
  `content` text COMMENT 'Comment text',
  `content_html` text COMMENT 'Sanitized text',
  `is_deleted` tinyint(1) unsigned DEFAULT NULL COMMENT 'Comment deleted?',
  `is_private` tinyint(1) unsigned DEFAULT '0' COMMENT 'Only for friends?',
  `rating` int(11) NOT NULL DEFAULT '0',
  `is_approved` tinyint(1) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `is_private` (`is_private`),
  KEY `rating` (`rating`),
  KEY `target_id` (`target_id`,`target_controller`,`target_subject`,`ordering`),
  KEY `author_url` (`author_url`),
  KEY `date_pub` (`date_pub`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='User comments';

DROP TABLE IF EXISTS `{#}comments_rating`;
CREATE TABLE `{#}comments_rating` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `comment_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `score` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comment_id` (`comment_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}comments_tracks`;
CREATE TABLE `{#}comments_tracks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL,
  `target_controller` varchar(32) DEFAULT NULL,
  `target_subject` varchar(32) DEFAULT NULL,
  `target_id` int(11) unsigned DEFAULT NULL,
  `target_url` varchar(250) DEFAULT NULL,
  `target_title` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `target_id` (`target_id`,`target_controller`,`target_subject`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User subscriptions to new comments';

DROP TABLE IF EXISTS `{#}content_datasets`;
CREATE TABLE `{#}content_datasets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id` int(11) unsigned DEFAULT NULL COMMENT 'Content typpe ID',
  `name` varchar(32) NOT NULL COMMENT 'Dataset title',
  `title` varchar(100) NOT NULL COMMENT 'Dataset heading',
  `description` text COMMENT 'Dataset description',
  `ordering` int(11) unsigned DEFAULT NULL COMMENT 'Order number',
  `is_visible` tinyint(1) unsigned DEFAULT NULL COMMENT 'Show dataset on site?',
  `filters` text NOT NULL COMMENT 'Dataset filters array',
  `sorting` text NOT NULL COMMENT 'Sorting rules array',
  `index` varchar(40) DEFAULT NULL COMMENT 'Index title',
  `groups_view` text COMMENT 'Show to groups',
  `groups_hide` text COMMENT 'Hide from groups',
  `seo_keys` varchar(256) DEFAULT NULL,
  `seo_desc` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `ordering` (`ordering`),
  KEY `is_visible` (`is_visible`),
  KEY `ctype_id` (`ctype_id`,`ordering`),
  KEY `index` (`index`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Content type datasets';

DROP TABLE IF EXISTS `{#}content_folders`;
CREATE TABLE `{#}content_folders` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`ctype_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}content_types`;
CREATE TABLE `{#}content_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `name` varchar(32) NOT NULL COMMENT 'System name',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description',
  `is_date_range` tinyint(1) unsigned DEFAULT NULL,
  `is_premod_add` tinyint(1) unsigned DEFAULT NULL COMMENT 'Pre-moderate new content?',
  `is_premod_edit` tinyint(1) unsigned DEFAULT NULL COMMENT 'Pre-moderate edited content',
  `is_cats` tinyint(1) unsigned DEFAULT NULL COMMENT 'Enable categories?',
  `is_cats_recursive` tinyint(1) unsigned DEFAULT NULL COMMENT 'End-to-end view of categories?',
  `is_folders` tinyint(1) unsigned DEFAULT NULL,
  `is_in_groups` tinyint(1) unsigned DEFAULT NULL COMMENT 'Create in groups',
  `is_in_groups_only` tinyint(1) unsigned DEFAULT NULL COMMENT 'Create only in groups',
  `is_comments` tinyint(1) unsigned DEFAULT NULL COMMENT 'Comments enabled?',
  `is_comments_tree` tinyint(1) unsigned DEFAULT NULL,
  `is_rating` tinyint(1) unsigned DEFAULT NULL COMMENT 'Allow rating?',
  `is_rating_pos` tinyint(1) unsigned DEFAULT NULL,
  `is_tags` tinyint(1) unsigned DEFAULT NULL,
  `is_auto_keys` tinyint(1) unsigned DEFAULT NULL COMMENT 'Autogeneration of keywords?',
  `is_auto_desc` tinyint(1) unsigned DEFAULT NULL COMMENT 'Autogeneration of description?',
  `is_auto_url` tinyint(1) unsigned DEFAULT NULL COMMENT 'Generate URL from title?',
  `is_fixed_url` tinyint(1) unsigned DEFAULT NULL COMMENT 'Do not change URL when editing an item?',
  `url_pattern` varchar(255) DEFAULT '{id}-{title}',
  `options` text COMMENT 'Options array',
  `labels` text COMMENT 'Labels array',
  `seo_keys` text COMMENT 'Keywords',
  `seo_desc` text COMMENT 'Description',
  `seo_title` varchar(255) DEFAULT NULL,
  `item_append_html` text,
  `is_fixed` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `is_cats` (`is_cats`),
  KEY `is_comments` (`is_comments`),
  KEY `is_comments_tree` (`is_comments_tree`),
  KEY `is_rating` (`is_rating`),
  KEY `is_rating_pos` (`is_rating_pos`),
  KEY `is_auto_keys` (`is_auto_keys`),
  KEY `is_auto_url` (`is_auto_url`),
  KEY `is_in_groups` (`is_in_groups`),
  KEY `is_in_groups_only` (`is_in_groups_only`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Content types';

INSERT INTO `{#}content_types` (`id`, `title`, `name`, `description`, `is_date_range`, `is_premod_add`, `is_premod_edit`, `is_cats`, `is_cats_recursive`, `is_folders`, `is_in_groups`, `is_in_groups_only`, `is_comments`, `is_comments_tree`, `is_rating`, `is_rating_pos`, `is_tags`, `is_auto_keys`, `is_auto_desc`, `is_auto_url`, `is_fixed_url`, `url_pattern`, `options`, `labels`, `seo_keys`, `seo_desc`, `seo_title`, `item_append_html`, `is_fixed`) VALUES
(1, 'Pages', 'pages', 'Static pages', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, NULL, '{id}-{title}', '---\nis_cats_change: null\nis_cats_open_root: null\nis_cats_only_last: null\nis_show_cats: null\nis_tags_in_list: null\nis_tags_in_item: null\nis_rss: null\nlist_on: null\nprofile_on: null\nlist_show_filter: null\nlist_expand_filter: null\nlist_style:\nitem_on: 1\nis_cats_keys: null\nis_cats_desc: null\nis_cats_auto_url: 1\n', '---\none: page\ntwo: pages\nmany: pages\ncreate: page\nlist:\nprofile:\n', NULL, NULL, NULL, NULL, 1),
(7, 'Photo albums', 'albums', 'User photo albums', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, 1, NULL, 1, 1, 1, 1, 1, '{id}-{title}', '---\nis_cats_change: null\nis_cats_open_root: null\nis_cats_only_last: null\nis_show_cats: null\nis_tags_in_list: null\nis_tags_in_item: 1\nis_rss: 1\nlist_on: 1\nprofile_on: 1\nlist_show_filter: null\nlist_expand_filter: null\nitem_on: 1\nis_cats_keys: null\nis_cats_desc: null\nis_cats_auto_url: 1\n', '---\none: album\ntwo: albums\nmany: albums\ncreate: album\nlist:\nprofile:\n', NULL, NULL, NULL, NULL, NULL);

DROP TABLE IF EXISTS `{#}controllers`;
CREATE TABLE `{#}controllers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `name` varchar(32) NOT NULL COMMENT 'System name',
  `is_enabled` tinyint(1) unsigned DEFAULT '1' COMMENT 'Enabled?',
  `options` text COMMENT 'Settings array',
  `author` varchar(128) NOT NULL COMMENT 'Author name',
  `url` varchar(250) DEFAULT NULL COMMENT 'Author site',
  `version` varchar(8) NOT NULL COMMENT 'Version',
  `is_backend` tinyint(1) unsigned DEFAULT NULL COMMENT 'Admin panel?',
  `is_external` tinyint(1) unsigned DEFAULT NULL COMMENT 'Third-party component',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `enabled` (`is_enabled`),
  KEY `is_backend` (`is_backend`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Components';

INSERT INTO `{#}controllers` (`id`, `title`, `name`, `is_enabled`, `options`, `author`, `url`, `version`, `is_backend`) VALUES
(1, 'Control Panel', 'admin', 1, NULL, 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 0),
(2, 'Content', 'content', 1, NULL, 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 0),
(3, 'User Profiles', 'users', 1, '---\nis_ds_online: 1\nis_ds_rating: 1\nis_ds_popular: 1\nis_filter: 1\nis_auth_only: null\nis_status: 1\nis_wall: 1\nis_themes_on: 1\nmax_tabs: 6\nis_friends_on: 1\nis_karma_comments: 1\nkarma_time: 30\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(4, 'Comments', 'comments', 1, '---\ndisable_icms_comments: null\nis_guests: null\nguest_ip_delay:\nrestricted_ips:\ndim_negative: 1\nupdate_user_rating: 1\nlimit: 20\nseo_keys:\nseo_desc:\nis_guests_moderate: 1\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(5, 'Private messages', 'messages', 1, '---\nlimit: 10\ngroups_allowed: \n  - 0\n', 'InstantCMS Team', 'http://www.instantcms.ru/', '2.0', 1),
(6, 'Authorization & Registration', 'auth', 1, '---\nis_reg_enabled: 1\nreg_reason: >\n  We apologize, but,\n  we do not accept\n  new users at the moment\nis_reg_invites: null\nreg_captcha: 1\nverify_email: null\nverify_exp: 48\nauth_captcha: 0\nrestricted_emails: |\n  *@shitmail.me\r\n  *@mailspeed.ru\r\n  *@temp-mail.ru\r\n  *@guerrillamail.com\r\n  *@12minutemail.com\r\n  *@mytempemail.com\r\n  *@spamobox.com\r\n  *@disposableinbox.com\r\n  *@filzmail.com\r\n  *@freemail.ms\r\n  *@anonymbox.com\r\n  *@lroid.com\r\n  *@yopmail.com\r\n  *@TempEmail.net\r\n  *@spambog.com\r\n  *@mailforspam.com\r\n  *@spam.su\r\n  *@no-spam.ws\r\n  *@mailinator.com\r\n  *@spamavert.com\r\n  *@trashcanmail.com\nrestricted_names: |\n  admin*\r\n  админ*\r\n  модератор\r\n  moderator\nrestricted_ips:\nis_invites: 1\nis_invites_strict: 1\ninvites_period: 7\ninvites_qty: 3\ninvites_min_karma: 0\ninvites_min_rating: 0\ninvites_min_days: 0\nreg_auto_auth: 1\nfirst_auth_redirect: profileedit\nauth_redirect: none\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(7, 'Activity Feed', 'activity', 1, '---\ntypes:\n  - 10\n  - 11\n  - 17\n  - 16\n  - 14\n  - 13\n  - 18\n  - 7\n  - 19\n  - 12\n  - 8\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(8, 'Groups', 'groups', 1, '---\nis_ds_rating: 1\nis_ds_popular: 1\nis_wall: 1\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(9, 'Markup Editor', 'markitup', 1, '---\nset: default-en\nskin: simple\nimages_upload: 1\nimages_w: 400\nimages_h: 400\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(10, 'Rating', 'rating', 1, '---\nis_hidden: 1\nis_show: 1\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(11, 'Wall', 'wall', 1, NULL, 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 0),
(12, 'reCAPTCHA', 'recaptcha', 1, '---\npublic_key: 6LdgRuESAAAAAKsuQoDeT_wPZ0YN6T0jGjKuHZRI\nprivate_key: 6LdgRuESAAAAAFaKHgCjfQlHVYh8v3aeYirFM0ow\ntheme: clean\nlang: en\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(13, 'Moderation Panel', 'moderation', 1, NULL, 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 0),
(14, 'Tags', 'tags', 1, NULL, 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(15, 'RSS feeds', 'rss', 1, NULL, 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(16, 'Sitemap generator', 'sitemap', 1, '---\nsources:\n  users|profiles: 1\n  groups|profiles: 1\n  content|pages: 1\n  content|articles: 1\n  content|posts: 1\n  content|albums: 1\n  content|board: 1\n  content|news: 1\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(17, 'Search', 'search', 1, '---\nctypes:\n  - articles\n  - posts\n  - albums\n  - board\n  - news\nperpage: 15\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(18, 'Photos', 'photos', 1, '---\nsizes:\n  - normal\n  - small\n  - big\nis_origs: 1\npreset: big\npreset_small: normal\ntypes: |\n  1 | Photo\r\n  2 | Vectors\r\n  3 | Illustrations\nordering: date_pub\nlimit: 20\ndownload_view:\n  normal:\n    - 0\n  related_photos:\n    - 0\n  micro:\n    - 0\n  small:\n    - 0\n  big:\n    - 0\n  original:\n    - 0\ndownload_hide:\n  normal: null\n  related_photos: null\n  micro: null\n  small: null\n  big: null\n  original:\n    - 1\n    - 3\n    - 4\nurl_pattern: ''{id}-{title}''\npreset_related: normal\nrelated_limit: 20\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(19, 'Image Upload', 'images', 1, NULL, 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(20, 'Redirects', 'redirect', 1, '---\nno_redirect_list:\nblack_list:\nis_check_link: null\nwhite_list:\nredirect_time: 10\n', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1),
(21, 'VK comments', 'commentsvk', 1, '---\napi_id: \nredesign: null\nautoPublish: 1\nnorealtime: null\nmini: 0\nattach:\n  - graffiti\n  - photo\n  - video\n  - audio\nlimit: 50\n', 'InstantCMS Team', 'http://www.instantcms.ru', '1.0', 1),
(22, 'Geobase', 'geo', 1, NULL, 'InstantCMS Team', 'http://www.instantcms.ru', '2.0', 1);

DROP TABLE IF EXISTS `{#}con_albums`;
CREATE TABLE `{#}con_albums` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `content` text,
  `slug` varchar(100) DEFAULT NULL,
  `seo_keys` varchar(256) DEFAULT NULL,
  `seo_desc` varchar(256) DEFAULT NULL,
  `seo_title` varchar(256) DEFAULT NULL,
  `tags` varchar(1000) DEFAULT NULL,
  `date_pub` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_last_modified` timestamp NULL DEFAULT NULL,
  `date_pub_end` timestamp NULL DEFAULT NULL,
  `is_pub` tinyint(1) DEFAULT '1',
  `hits_count` int(11) DEFAULT '0',
  `user_id` int(11) unsigned DEFAULT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  `parent_type` varchar(32) DEFAULT NULL,
  `parent_title` varchar(100) DEFAULT NULL,
  `parent_url` varchar(255) DEFAULT NULL,
  `is_parent_hidden` tinyint(1) DEFAULT NULL,
  `category_id` int(11) unsigned NOT NULL DEFAULT '1',
  `folder_id` int(11) unsigned DEFAULT NULL,
  `is_comments_on` tinyint(1) unsigned DEFAULT '1',
  `comments` int(11) NOT NULL DEFAULT '0',
  `rating` int(11) NOT NULL DEFAULT '0',
  `is_approved` tinyint(1) DEFAULT '1',
  `approved_by` int(11) DEFAULT NULL,
  `date_approved` timestamp NULL DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `cover_image` text,
  `photos_count` int(11) NOT NULL DEFAULT '0',
  `is_public` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `folder_id` (`folder_id`),
  KEY `slug` (`slug`),
  KEY `date_pub` (`is_pub`,`is_parent_hidden`,`is_approved`,`date_pub`),
  KEY `parent_id` (`parent_id`,`parent_type`,`date_pub`),
  KEY `user_id` (`user_id`,`date_pub`),
  KEY `date_pub_end` (`date_pub_end`),
  FULLTEXT KEY `title` (`title`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}con_albums_cats`;
CREATE TABLE `{#}con_albums_cats` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) unsigned DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `slug_key` varchar(255) DEFAULT NULL,
  `seo_keys` varchar(256) DEFAULT NULL,
  `seo_desc` varchar(256) DEFAULT NULL,
  `seo_title` varchar(256) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  `ns_left` int(11) DEFAULT NULL,
  `ns_right` int(11) DEFAULT NULL,
  `ns_level` int(11) DEFAULT NULL,
  `ns_differ` varchar(32) NOT NULL DEFAULT '',
  `ns_ignore` tinyint(4) NOT NULL DEFAULT '0',
  `allow_add` text,
  PRIMARY KEY (`id`),
  KEY `ordering` (`ordering`),
  KEY `slug` (`slug`),
  KEY `ns_left` (`ns_level`,`ns_right`,`ns_left`),
  KEY `parent_id` (`parent_id`,`ns_left`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}con_albums_cats` (`id`, `parent_id`, `title`, `slug`, `slug_key`, `seo_keys`, `seo_desc`, `seo_title`, `ordering`, `ns_left`, `ns_right`, `ns_level`, `ns_differ`, `ns_ignore`) VALUES
(1, 0, '---', NULL, NULL, NULL, NULL, NULL, 1, 1, 2, 0, '', 0);

DROP TABLE IF EXISTS `{#}con_albums_cats_bind`;
CREATE TABLE `{#}con_albums_cats_bind` (
  `item_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  KEY `item_id` (`item_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}con_albums_fields`;
CREATE TABLE `{#}con_albums_fields` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id` int(11) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `hint` varchar(200) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  `fieldset` varchar(32) DEFAULT NULL,
  `type` varchar(16) DEFAULT NULL,
  `is_in_list` tinyint(1) DEFAULT NULL,
  `is_in_item` tinyint(1) DEFAULT NULL,
  `is_in_filter` tinyint(1) DEFAULT NULL,
  `is_private` tinyint(1) DEFAULT NULL,
  `is_fixed` tinyint(1) DEFAULT NULL,
  `is_fixed_type` tinyint(1) DEFAULT NULL,
  `is_system` tinyint(1) DEFAULT NULL,
  `values` text,
  `options` text,
  `groups_read` text,
  `groups_edit` text,
  `filter_view` text,
  PRIMARY KEY (`id`),
  KEY `ordering` (`ordering`),
  KEY `is_in_list` (`is_in_list`),
  KEY `is_in_item` (`is_in_item`),
  KEY `is_in_filter` (`is_in_filter`),
  KEY `is_private` (`is_private`),
  KEY `is_fixed` (`is_fixed`),
  KEY `is_fixed_type` (`is_fixed_type`),
  KEY `is_system` (`is_system`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}con_albums_fields` (`id`, `ctype_id`, `name`, `title`, `hint`, `ordering`, `fieldset`, `type`, `is_in_list`, `is_in_item`, `is_in_filter`, `is_private`, `is_fixed`, `is_fixed_type`, `is_system`, `values`, `options`, `groups_read`, `groups_edit`) VALUES
(1, 7, 'title', 'Album title', NULL, 1, NULL, 'caption', 1, 1, 1, NULL, 1, 1, 0, NULL, '---\nlabel_in_list: none\nlabel_in_item: none\nis_required: 1\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n'),
(2, 7, 'date_pub', 'Publication date', NULL, 2, NULL, 'date', 1, 1, 1, NULL, 1, 1, 1, NULL, '---\nlabel_in_list: none\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n'),
(3, 7, 'user', 'Author', NULL, 3, NULL, 'user', 1, 1, NULL, NULL, 1, 1, 1, NULL, '---\nlabel_in_list: none\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n'),
(4, 7, 'content', 'Album description', NULL, 4, NULL, 'text', 1, 1, NULL, NULL, 1, NULL, NULL, NULL, '---\nmin_length: 0\nmax_length: 2048\nis_html_filter: null\nlabel_in_list: none\nlabel_in_item: none\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n'),
(5, 7, 'cover_image', 'Album cover image', NULL, 5, NULL, 'image', 1, NULL, NULL, NULL, 1, 1, 1, NULL, '---\nlabel_in_list: left\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n'),
(6, 7, 'is_public', 'Public photo album', 'Other users will be able to upload photos in this album', 6, NULL, 'checkbox', 0, 0, NULL, NULL, 1, NULL, NULL, NULL, '---\nlabel_in_list: none\nlabel_in_item: none\n', NULL, NULL);

DROP TABLE IF EXISTS `{#}con_albums_props`;
CREATE TABLE `{#}con_albums_props` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `fieldset` varchar(32) DEFAULT NULL,
  `type` varchar(16) DEFAULT NULL,
  `is_in_filter` tinyint(1) DEFAULT NULL,
  `values` text,
  `options` text,
  PRIMARY KEY (`id`),
  KEY `is_active` (`is_in_filter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}con_albums_props_bind`;
CREATE TABLE `{#}con_albums_props_bind` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `prop_id` int(11) DEFAULT NULL,
  `cat_id` int(11) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prop_id` (`prop_id`),
  KEY `ordering` (`cat_id`,`ordering`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}con_albums_props_values`;
CREATE TABLE `{#}con_albums_props_values` (
  `prop_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  KEY `prop_id` (`prop_id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}con_pages`;
CREATE TABLE `{#}con_pages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `content` text,
  `slug` varchar(100) DEFAULT NULL,
  `seo_keys` varchar(256) DEFAULT NULL,
  `seo_desc` varchar(256) DEFAULT NULL,
  `seo_title` varchar(256) DEFAULT NULL,
  `tags` varchar(1000) DEFAULT NULL,
  `date_pub` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_last_modified` timestamp NULL DEFAULT NULL,
  `date_pub_end` timestamp NULL DEFAULT NULL,
  `is_pub` tinyint(1) DEFAULT '1',
  `hits_count` int(11) DEFAULT '0',
  `user_id` int(11) unsigned DEFAULT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  `parent_type` varchar(32) DEFAULT NULL,
  `parent_title` varchar(100) DEFAULT NULL,
  `parent_url` varchar(255) DEFAULT NULL,
  `is_parent_hidden` tinyint(1) DEFAULT NULL,
  `category_id` int(11) unsigned NOT NULL DEFAULT '1',
  `folder_id` int(11) unsigned DEFAULT NULL,
  `is_comments_on` tinyint(1) unsigned DEFAULT '1',
  `comments` int(11) NOT NULL DEFAULT '0',
  `rating` int(11) NOT NULL DEFAULT '0',
  `is_approved` tinyint(1) DEFAULT '1',
  `approved_by` int(11) DEFAULT NULL,
  `date_approved` timestamp NULL DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `attach` text,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `folder_id` (`folder_id`),
  KEY `slug` (`slug`),
  KEY `date_pub` (`is_pub`,`is_parent_hidden`,`is_approved`,`date_pub`),
  KEY `parent_id` (`parent_id`,`parent_type`,`date_pub`),
  KEY `user_id` (`user_id`,`date_pub`),
  KEY `date_pub_end` (`date_pub_end`),
  FULLTEXT KEY `title` (`title`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}con_pages_cats`;
CREATE TABLE `{#}con_pages_cats` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) unsigned DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `slug_key` varchar(255) DEFAULT NULL,
  `seo_keys` varchar(256) DEFAULT NULL,
  `seo_desc` varchar(256) DEFAULT NULL,
  `seo_title` varchar(256) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  `ns_left` int(11) DEFAULT NULL,
  `ns_right` int(11) DEFAULT NULL,
  `ns_level` int(11) DEFAULT NULL,
  `ns_differ` varchar(32) NOT NULL DEFAULT '',
  `ns_ignore` tinyint(4) NOT NULL DEFAULT '0',
  `allow_add` text,
  PRIMARY KEY (`id`),
  KEY `ordering` (`ordering`),
  KEY `slug` (`slug`),
  KEY `ns_left` (`ns_level`,`ns_right`,`ns_left`),
  KEY `parent_id` (`parent_id`,`ns_left`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}con_pages_cats` (`id`, `parent_id`, `title`, `slug`, `slug_key`, `seo_keys`, `seo_desc`, `seo_title`, `ordering`, `ns_left`, `ns_right`, `ns_level`, `ns_differ`, `ns_ignore`) VALUES
(1, 0, '---', NULL, NULL, NULL, NULL, NULL, 1, 1, 2, 0, '', 0);

DROP TABLE IF EXISTS `{#}con_pages_cats_bind`;
CREATE TABLE `{#}con_pages_cats_bind` (
  `item_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  KEY `item_id` (`item_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}con_pages_fields`;
CREATE TABLE `{#}con_pages_fields` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id` int(11) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `hint` varchar(200) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  `fieldset` varchar(32) DEFAULT NULL,
  `type` varchar(16) DEFAULT NULL,
  `is_in_list` tinyint(1) DEFAULT NULL,
  `is_in_item` tinyint(1) DEFAULT NULL,
  `is_in_filter` tinyint(1) DEFAULT NULL,
  `is_private` tinyint(1) DEFAULT NULL,
  `is_fixed` tinyint(1) DEFAULT NULL,
  `is_fixed_type` tinyint(1) DEFAULT NULL,
  `is_system` tinyint(1) DEFAULT NULL,
  `values` text,
  `options` text,
  `groups_read` text,
  `groups_edit` text,
  `filter_view` text,
  PRIMARY KEY (`id`),
  KEY `ordering` (`ordering`),
  KEY `is_in_list` (`is_in_list`),
  KEY `is_in_item` (`is_in_item`),
  KEY `is_in_filter` (`is_in_filter`),
  KEY `is_private` (`is_private`),
  KEY `is_fixed` (`is_fixed`),
  KEY `is_system` (`is_system`),
  KEY `is_fixed_type` (`is_fixed_type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}con_pages_fields` (`id`, `ctype_id`, `name`, `title`, `hint`, `ordering`, `fieldset`, `type`, `is_in_list`, `is_in_item`, `is_in_filter`, `is_private`, `is_fixed`, `is_fixed_type`, `is_system`, `values`, `options`, `groups_read`, `groups_edit`) VALUES
(1, 1, 'title', 'Title', NULL, 1, NULL, 'caption', 1, 1, 1, NULL, 1, 1, NULL, NULL, '---\nlabel_in_list: none\nlabel_in_item: none\nis_required: 1\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n'),
(2, 1, 'date_pub', 'Publication date', NULL, 2, NULL, 'date', NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, '---\nlabel_in_list: none\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n'),
(3, 1, 'user', 'Author', NULL, 3, NULL, 'age', NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, '---\nlabel_in_list: none\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n'),
(4, 1, 'content', 'Page content', NULL, 4, NULL, 'html', NULL, 1, NULL, NULL, 1, NULL, NULL, NULL, '---\neditor: redactor\nis_html_filter: null\nteaser_len:\nlabel_in_list: none\nlabel_in_item: none\nis_required: 1\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n'),
(5, 1, 'attach', 'Download', 'Attach a file to the page', 5, NULL, 'file', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, '---\nshow_name: 0\nextensions: jpg, gif, png\nmax_size_mb: 2\nshow_size: 1\nlabel_in_list: none\nlabel_in_item: none\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\nis_unique: null\nprofile_value:\n', '---\n- 0\n', '---\n- 0\n');

DROP TABLE IF EXISTS `{#}con_pages_props`;
CREATE TABLE `{#}con_pages_props` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `fieldset` varchar(32) DEFAULT NULL,
  `type` varchar(16) DEFAULT NULL,
  `is_in_filter` tinyint(1) DEFAULT NULL,
  `values` text,
  `options` text,
  PRIMARY KEY (`id`),
  KEY `is_active` (`is_in_filter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}con_pages_props_bind`;
CREATE TABLE `{#}con_pages_props_bind` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `prop_id` int(11) DEFAULT NULL,
  `cat_id` int(11) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prop_id` (`prop_id`),
  KEY `ordering` (`cat_id`,`ordering`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}con_pages_props_values`;
CREATE TABLE `{#}con_pages_props_values` (
  `prop_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  KEY `prop_id` (`prop_id`),
  KEY `item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}events`;
CREATE TABLE `{#}events` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `event` varchar(32) NOT NULL COMMENT 'Event',
  `listener` varchar(32) NOT NULL COMMENT 'Listener (component)',
  `ordering` int(11) DEFAULT NULL COMMENT 'Order number',
  PRIMARY KEY (`id`),
  KEY `hook` (`event`),
  KEY `listener` (`listener`),
  KEY `ordering` (`ordering`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Binding hooks to events';

INSERT INTO `{#}events` (`id`, `event`, `listener`, `ordering`) VALUES
(1, 'user_logged', 'users', 1),
(2, 'menu_content', 'content', 1),
(3, 'menu_admin', 'admin', 1),
(4, 'menu_users', 'users', 1),
(5, 'menu_messages', 'messages', 1);

DROP TABLE IF EXISTS `{#}groups`;
CREATE TABLE `{#}groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) unsigned DEFAULT NULL COMMENT 'Owner',
  `date_pub` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation date',
  `title` varchar(128) NOT NULL COMMENT 'Title',
  `description` text COMMENT 'Description',
  `logo` text COMMENT 'Group logo',
  `rating` int(11) NOT NULL DEFAULT '0' COMMENT 'Rating',
  `members_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Number of members',
  `join_policy` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Join policy',
  `edit_policy` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Edit policy',
  `wall_policy` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Wall policy',
  `is_closed` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Private?',
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  KEY `date_pub` (`date_pub`),
  KEY `rating` (`rating`),
  KEY `is_public` (`join_policy`),
  KEY `is_closed` (`is_closed`),
  KEY `members_count` (`members_count`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Groups (communities)';

DROP TABLE IF EXISTS `{#}groups_invites`;
CREATE TABLE `{#}groups_invites` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned DEFAULT NULL COMMENT 'Group ID',
  `user_id` int(11) unsigned DEFAULT NULL COMMENT 'Inviter ID',
  `invited_id` int(11) unsigned DEFAULT NULL COMMENT 'Invited user ID',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`),
  KEY `invited_id` (`invited_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Invitations to groups';

DROP TABLE IF EXISTS `{#}groups_members`;
CREATE TABLE `{#}groups_members` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `role` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT 'User role in a group',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Role update date',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`),
  KEY `date_updated` (`date_updated`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Group (community) members';

DROP TABLE IF EXISTS `{#}images_presets`;
CREATE TABLE `{#}images_presets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `width` int(11) unsigned DEFAULT NULL,
  `height` int(11) unsigned DEFAULT NULL,
  `is_square` tinyint(1) unsigned DEFAULT NULL,
  `is_watermark` tinyint(1) unsigned DEFAULT NULL,
  `wm_image` text,
  `wm_origin` varchar(16) DEFAULT NULL,
  `wm_margin` int(11) unsigned DEFAULT NULL,
  `is_internal` tinyint(1) unsigned DEFAULT NULL,
  `quality` tinyint(1) NOT NULL DEFAULT '90',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `is_square` (`is_square`),
  KEY `is_watermark` (`is_watermark`),
  KEY `is_internal` (`is_internal`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}images_presets` (`id`, `name`, `title`, `width`, `height`, `is_square`, `is_watermark`, `wm_image`, `wm_origin`, `wm_margin`, `is_internal`) VALUES
(1, 'micro', 'Micro', 32, 32, 1, NULL, NULL, NULL, NULL, NULL),
(2, 'small', 'Small', 64, 64, 1, NULL, NULL, NULL, NULL, NULL),
(3, 'normal', 'Medium', NULL, 256, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 'big', 'Big', 690, 690, NULL, NULL, NULL, 'bottom-right', NULL, NULL),
(5, 'wysiwyg_markitup', 'Editor: markItUp!', 400, 400, NULL, NULL, NULL, 'top-left', NULL, 1),
(6, 'wysiwyg_redactor', 'Editor: Redactor', 800, 800, NULL, NULL, NULL, 'top-left', NULL, 1),
(7, 'wysiwyg_live', 'Editor: Live', 690, 690, NULL, NULL, NULL, 'top-left', NULL, 1);

DROP TABLE IF EXISTS `{#}menu`;
CREATE TABLE `{#}menu` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL COMMENT 'System name',
  `title` varchar(64) DEFAULT NULL COMMENT 'Menu title',
  `is_fixed` tinyint(1) unsigned DEFAULT NULL COMMENT 'Forbidden to delete?',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Site menu';

INSERT INTO `{#}menu` (`id`, `name`, `title`, `is_fixed`) VALUES
(1, 'main', 'Main menu', 1),
(2, 'personal', 'Personal Menu', 1),
(4, 'toolbar', 'Actions menu', 1),
(5, 'header', 'Header menu', NULL);

DROP TABLE IF EXISTS `{#}menu_items`;
CREATE TABLE `{#}menu_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `menu_id` int(11) unsigned DEFAULT NULL COMMENT 'Menu ID',
  `parent_id` int(11) unsigned DEFAULT '0' COMMENT 'Parent item ID',
  `title` varchar(64) DEFAULT NULL COMMENT 'Item title',
  `url` varchar(255) DEFAULT NULL COMMENT 'URL',
  `ordering` int(11) unsigned DEFAULT NULL COMMENT 'Order number',
  `options` text COMMENT 'Options array',
  `groups_view` text COMMENT 'Allowed user groups array',
  `groups_hide` text COMMENT 'Disallowed user groups array',
  PRIMARY KEY (`id`),
  KEY `menu_id` (`menu_id`),
  KEY `parent_id` (`parent_id`),
  KEY `ordering` (`ordering`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Menu items';

INSERT INTO `{#}menu_items` (`id`, `menu_id`, `parent_id`, `title`, `url`, `ordering`, `options`, `groups_view`, `groups_hide`) VALUES
(6, 1, 0, 'Photos', 'albums', 4, '---\ntarget: _self\nclass:', '---\n- 0\n', NULL),
(13, 2, 0, 'My profile', 'users/{user.id}', 1, '---\ntarget: _self\nclass: profile', '---\n- 0\n', NULL),
(14, 2, 0, 'My messages', '{messages:view}', 2, '---\ntarget: _self\nclass: messages messages-counter ajax-modal', '---\n- 0\n', NULL),
(24, 2, 0, 'Add', '{content:add}', 6, '---\ntarget: _self\nclass: add', '---\n- 0\n', NULL),
(25, 2, 0, 'Control panel', '{admin:menu}', 7, '---\ntarget: _self\nclass: cpanel', '---\n- 6\n', NULL),
(29, 1, 0, 'Users', 'users', 8, '---\ntarget: _self\nclass:', '---\n- 0\n', NULL),
(30, 2, 0, 'Notifications', '{messages:notices}', 3, '---\ntarget: _self\nclass: info notices-counter ajax-modal', '---\n- 0\n', NULL),
(31, 1, 0, 'Activity', 'activity', 6, '---\ntarget: _self\nclass:', '---\n- 0\n', NULL),
(32, 1, 0, 'Groups', 'groups', 5, '---\ntarget: _self\nclass:', '---\n- 0\n', NULL),
(33, 2, 0, 'My groups', '{groups:my}', 5, '---\ntarget: _self\nclass: group', '---\n- 0\n', NULL),
(34, 5, 0, 'Log in', 'auth/login', 9, '---\ntarget: _self\nclass: ajax-modal key', '---\n- 1\n', NULL),
(35, 5, 0, 'Sign up', 'auth/register', 10, '---\ntarget: _self\nclass: user_add', '---\n- 1\n', NULL),
(37, 2, 0, 'Moderation', '{moderation:panel}', 4, '---\ntarget: _self\nclass: checklist', '---\n- 5\n- 6\n', NULL),
(38, 1, 0, 'Comments', 'comments', 7, '---\ntarget: _self\nclass:', '---\n- 0\n', NULL),
(43, 2, 0, 'Log out', 'auth/logout', 12, '---\ntarget: _self\nclass: logout', '---\n- 0\n', NULL);

DROP TABLE IF EXISTS `{#}moderators`;
CREATE TABLE `{#}moderators` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL,
  `date_assigned` timestamp NULL DEFAULT NULL,
  `ctype_name` varchar(32) DEFAULT NULL,
  `count_approved` int(11) unsigned NOT NULL DEFAULT '0',
  `count_deleted` int(11) unsigned NOT NULL DEFAULT '0',
  `count_idle` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `ctype_name` (`ctype_name`),
  KEY `count_idle` (`count_idle`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}moderators_tasks`;
CREATE TABLE `{#}moderators_tasks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `moderator_id` int(11) unsigned DEFAULT NULL,
  `author_id` int(11) unsigned DEFAULT NULL,
  `item_id` int(11) unsigned DEFAULT NULL,
  `ctype_name` varchar(32) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `url` varchar(256) DEFAULT NULL,
  `date_pub` timestamp NULL DEFAULT NULL,
  `is_new_item` tinyint(1) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `moderator_id` (`moderator_id`),
  KEY `author_id` (`author_id`),
  KEY `ctype_name` (`ctype_name`),
  KEY `date_pub` (`date_pub`),
  KEY `item_id` (`item_id`),
  KEY `is_new` (`is_new_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `{#}perms_rules`;
CREATE TABLE `{#}perms_rules` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `controller` varchar(32) DEFAULT NULL COMMENT 'Component (owner)',
  `name` varchar(32) NOT NULL COMMENT 'Rule title',
  `type` enum('flag','list','number') NOT NULL DEFAULT 'flag' COMMENT 'Selection type (flag,list...)',
  `options` varchar(128) DEFAULT NULL COMMENT 'An array of possible values',
  PRIMARY KEY (`id`),
  KEY `controller` (`controller`),
  KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='A list of all available permission rules';

INSERT INTO `{#}perms_rules` (`id`, `controller`, `name`, `type`, `options`) VALUES
(1, 'content', 'add', 'flag', NULL),
(2, 'content', 'edit', 'list', 'own,all'),
(3, 'content', 'delete', 'list', 'own,all'),
(4, 'content', 'add_cat', 'flag', NULL),
(5, 'content', 'edit_cat', 'flag', NULL),
(6, 'content', 'delete_cat', 'flag', NULL),
(8, 'content', 'rate', 'flag', NULL),
(9, 'content', 'privacy', 'flag', NULL),
(10, 'comments', 'add', 'flag', NULL),
(11, 'comments', 'edit', 'list', 'own,all'),
(12, 'comments', 'delete', 'list', 'own,all,full_delete'),
(13, 'content', 'view_all', 'flag', NULL),
(14, 'comments', 'view_all', 'flag', NULL),
(15, 'groups', 'add', 'flag', NULL),
(16, 'groups', 'edit', 'list', 'own,all'),
(17, 'groups', 'delete', 'list', 'own,all'),
(18, 'content', 'limit', 'number', NULL),
(19, 'users', 'vote_karma', 'flag', NULL),
(20, 'comments', 'rate', 'flag', NULL),
(21, 'comments', 'karma', 'number', NULL),
(22, 'content', 'karma', 'number', NULL),
(23, 'activity', 'delete', 'flag', NULL),
(24, 'content', 'pub_late', 'flag', NULL),
(25, 'content', 'pub_long', 'list', 'days,any'),
(26, 'content', 'pub_max_days', 'number', NULL),
(27, 'content', 'pub_max_ext', 'flag', NULL),
(28, 'content', 'pub_on', 'flag', NULL),
(29, 'content', 'disable_comments', 'flag', NULL),
(30, 'comments', 'add_approved', 'flag', NULL),
(31, 'comments', 'is_moderator', 'flag', NULL);

DROP TABLE IF EXISTS `{#}perms_users`;
CREATE TABLE `{#}perms_users` (
  `rule_id` int(11) unsigned DEFAULT NULL COMMENT 'Rule ID',
  `group_id` int(11) unsigned DEFAULT NULL COMMENT 'Group ID',
  `subject` varchar(32) DEFAULT NULL COMMENT 'Rule subject',
  `value` varchar(16) NOT NULL COMMENT 'Rule value',
  KEY `rule_id` (`rule_id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Binding permission rules to user groups';

INSERT INTO `{#}perms_users` (`rule_id`, `group_id`, `subject`, `value`) VALUES
(10, 4, 'comments', '1'),
(11, 4, 'comments', 'own'),
(15, 4, 'groups', '1'),
(17, 4, 'groups', 'own'),
(16, 4, 'groups', 'own'),
(19, 4, 'users', '1'),
(10, 5, 'comments', '1'),
(12, 5, 'comments', 'all'),
(11, 5, 'comments', 'all'),
(14, 5, 'comments', '1'),
(15, 5, 'groups', '1'),
(17, 5, 'groups', 'all'),
(16, 5, 'groups', 'all'),
(19, 5, 'users', '1'),
(10, 3, 'comments', '1'),
(12, 3, 'comments', 'own'),
(11, 3, 'comments', 'own'),
(1, 4, 'albums', '1'),
(1, 5, 'albums', '1'),
(1, 6, 'albums', '1'),
(3, 4, 'albums', 'own'),
(3, 5, 'albums', 'all'),
(3, 6, 'albums', 'all'),
(2, 4, 'albums', 'own'),
(2, 5, 'albums', 'all'),
(2, 6, 'albums', 'all'),
(9, 4, 'albums', '1'),
(9, 5, 'albums', '1'),
(9, 6, 'albums', '1'),
(8, 4, 'albums', '1'),
(8, 5, 'albums', '1'),
(8, 6, 'albums', '1'),
(13, 5, 'albums', '1'),
(13, 6, 'albums', '1'),
(10, 6, 'comments', '1'),
(12, 6, 'comments', 'all'),
(11, 6, 'comments', 'all'),
(20, 4, 'comments', '1'),
(20, 5, 'comments', '1'),
(20, 6, 'comments', '1'),
(14, 6, 'comments', '1'),
(21, 4, 'comments', '1'),
(23, 5, 'activity', '1'),
(23, 6, 'activity', '1'),
(1, 3, 'albums', '1'),
(3, 3, 'albums', 'own'),
(2, 3, 'albums', 'own');

DROP TABLE IF EXISTS `{#}photos`;
CREATE TABLE `{#}photos` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `date_pub` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_photo` timestamp NULL DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `content_source` text,
  `content` text,
  `image` text NOT NULL,
  `exif` varchar(250) DEFAULT NULL,
  `height` smallint(5) unsigned NOT NULL DEFAULT '0',
  `width` smallint(5) unsigned NOT NULL DEFAULT '0',
  `sizes` varchar(250) DEFAULT NULL,
  `rating` int(11) NOT NULL DEFAULT '0',
  `comments` int(11) unsigned DEFAULT '0',
  `hits_count` int(11) unsigned NOT NULL DEFAULT '0',
  `orientation` enum('square','landscape','portrait','') DEFAULT NULL,
  `type` tinyint(3) unsigned DEFAULT NULL,
  `camera` varchar(50) DEFAULT NULL,
  `slug` varchar(100) DEFAULT NULL,
  `is_private` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `ordering` int(11) unsigned NOT NULL DEFAULT '0',
  `downloads_count` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`date_pub`),
  KEY `album_id` (`album_id`,`date_pub`,`id`),
  KEY `slug` (`slug`),
  KEY `camera` (`camera`),
  KEY `ordering` (`ordering`),
  FULLTEXT KEY `title` (`title`,`content`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}rating_log`;
CREATE TABLE `{#}rating_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL COMMENT 'User ID',
  `target_controller` varchar(32) DEFAULT NULL COMMENT 'Component (target content owner)',
  `target_subject` varchar(32) DEFAULT NULL COMMENT 'Subject (target content type)',
  `target_id` int(11) unsigned DEFAULT NULL COMMENT 'Subject ID (target content items)',
  `score` tinyint(1) DEFAULT NULL COMMENT 'Score value',
  `ip` int(10) unsigned DEFAULT NULL COMMENT 'ip-address',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `target_id` (`target_id`,`target_controller`,`target_subject`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Rating scores';

DROP TABLE IF EXISTS `{#}rss_feeds`;
CREATE TABLE `{#}rss_feeds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id` int(11) unsigned DEFAULT NULL,
  `ctype_name` varchar(32) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `description` text,
  `image` text,
  `mapping` text,
  `limit` int(11) unsigned NOT NULL DEFAULT '15',
  `is_enabled` tinyint(1) unsigned DEFAULT NULL,
  `is_cache` tinyint(1) unsigned DEFAULT NULL,
  `cache_interval` int(11) unsigned DEFAULT '60',
  `date_cached` timestamp NULL DEFAULT NULL,
  `template` varchar(30) NOT NULL DEFAULT 'feed' COMMENT 'Feed template',
  PRIMARY KEY (`id`),
  KEY `ctype_id` (`ctype_id`),
  KEY `ctype_name` (`ctype_name`),
  KEY `is_enabled` (`is_enabled`),
  KEY `is_cache` (`is_cache`),
  KEY `cache_interval` (`cache_interval`),
  KEY `date_cached` (`date_cached`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}rss_feeds` (`id`, `ctype_id`, `ctype_name`, `title`, `description`, `image`, `mapping`, `limit`, `is_enabled`, `is_cache`, `cache_interval`, `date_cached`) VALUES
(4, 7, 'albums', 'Photo albums', NULL, NULL, '---\ntitle: title\ndescription: content\npubDate: date_pub\nimage: cover_image\nimage_size: normal\n', 15, 1, NULL, 60, NULL);

DROP TABLE IF EXISTS `{#}scheduler_tasks`;
CREATE TABLE `{#}scheduler_tasks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(250) DEFAULT NULL,
  `controller` varchar(32) DEFAULT NULL,
  `hook` varchar(32) DEFAULT NULL,
  `period` int(11) unsigned DEFAULT NULL,
  `date_last_run` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) unsigned DEFAULT NULL,
  `is_new` tinyint(1) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `period` (`period`),
  KEY `date_last_run` (`date_last_run`),
  KEY `is_enabled` (`is_active`),
  KEY `is_new` (`is_new`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}scheduler_tasks` (`id`, `title`, `controller`, `hook`, `period`, `date_last_run`, `is_active`, `is_new`) VALUES
(1, 'User migrations between groups', 'users', 'migration', 1440, NULL, 1, 0),
(2, 'Sitemap generation', 'sitemap', 'generate', 1440, NULL, 1, 0),
(3, 'Issuing invitations to users', 'auth', 'send_invites', 1440, NULL, 1, 0),
(4, 'Publish Content on a schedule', 'content', 'publication', 1440, NULL, 1, 1),
(5, 'Cleaning deleted private messages', 'messages', 'clean', 1440, NULL, 1, 1),
(6, 'Delete unverified users', 'auth', 'delete_expired_unverified', 60, NULL, 1, 1);

DROP TABLE IF EXISTS `{#}sessions_online`;
CREATE TABLE `{#}sessions_online` (
  `session_id` varchar(32) DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `session_id` (`session_id`),
  KEY `user_id` (`user_id`),
  KEY `date_created` (`date_created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}tags`;
CREATE TABLE `{#}tags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag` varchar(32) NOT NULL,
  `frequency` int(11) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tag` (`tag`),
  UNIQUE KEY `frequency` (`frequency`,`tag`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Tag list';

DROP TABLE IF EXISTS `{#}tags_bind`;
CREATE TABLE `{#}tags_bind` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) unsigned DEFAULT NULL,
  `target_controller` varchar(32) DEFAULT NULL,
  `target_subject` varchar(32) DEFAULT NULL,
  `target_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `target_id` (`target_id`,`target_controller`,`target_subject`),
  KEY `tag_id` (`tag_id`),
  KEY `target_controller` (`target_controller`,`target_subject`,`tag_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Binding tags to content';

DROP TABLE IF EXISTS `{#}uploaded_files`;
CREATE TABLE `{#}uploaded_files` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `url_key` varchar(32) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `counter` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `url_key` (`url_key`),
  KEY `counter` (`counter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}users_auth_tokens`;
CREATE TABLE `{#}users_auth_tokens` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `auth_token` varchar(32) DEFAULT NULL,
  `date_auth` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `date_log` timestamp NULL DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `access_type` varchar(100) DEFAULT NULL,
  `ip` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_token` (`auth_token`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}users`;
CREATE TABLE `{#}users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `groups` text COMMENT 'User groups array',
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL COMMENT 'Password hash',
  `password_salt` varchar(16) DEFAULT NULL COMMENT 'Password salt',
  `is_admin` tinyint(1) unsigned DEFAULT NULL COMMENT 'Administrator?',
  `nickname` varchar(100) NOT NULL COMMENT 'Name',
  `date_reg` timestamp NULL DEFAULT NULL COMMENT 'Sign up date',
  `date_log` timestamp NULL DEFAULT NULL COMMENT 'Last log in',
  `date_group` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Last group change date',
  `ip` varchar(45) DEFAULT NULL,
  `is_locked` tinyint(1) unsigned DEFAULT NULL COMMENT 'Blocked',
  `lock_until` timestamp NULL DEFAULT NULL COMMENT 'Blocked till',
  `lock_reason` varchar(250) DEFAULT NULL COMMENT 'Blocking reason',
  `pass_token` varchar(32) DEFAULT NULL COMMENT 'Password recovery key',
  `date_token` timestamp NULL DEFAULT NULL COMMENT 'Password recovery key creation date',
  `files_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Number of uploaded files',
  `friends_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Number of friends',
  `time_zone` varchar(32) DEFAULT NULL COMMENT 'Time zone',
  `karma` int(11) NOT NULL DEFAULT '0' COMMENT 'Reputation',
  `rating` int(11) NOT NULL DEFAULT '0' COMMENT 'Rating',
  `theme` text COMMENT 'Profile theme settings',
  `notify_options` text COMMENT 'Notification settings',
  `privacy_options` text COMMENT 'Privacy settings',
  `status_id` int(11) unsigned DEFAULT NULL COMMENT 'Text status',
  `status_text` varchar(140) DEFAULT NULL COMMENT 'Status text',
  `inviter_id` int(11) unsigned DEFAULT NULL,
  `invites_count` int(11) unsigned NOT NULL DEFAULT '0',
  `date_invites` timestamp NULL DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `city` int(11) unsigned DEFAULT NULL,
  `city_cache` varchar(128) DEFAULT NULL,
  `hobby` text,
  `avatar` text,
  `icq` varchar(255) DEFAULT NULL,
  `skype` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `music` varchar(255) DEFAULT NULL,
  `movies` varchar(255) DEFAULT NULL,
  `site` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `pass_token` (`pass_token`),
  KEY `birth_date` (`birth_date`),
  KEY `city` (`city`),
  KEY `is_admin` (`is_admin`),
  KEY `friends_count` (`friends_count`),
  KEY `karma` (`karma`),
  KEY `rating` (`rating`),
  KEY `is_locked` (`is_locked`),
  KEY `date_reg` (`date_reg`),
  KEY `date_log` (`date_log`),
  KEY `date_group` (`date_group`),
  KEY `inviter_id` (`inviter_id`),
  KEY `date_invites` (`date_invites`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Users';

INSERT INTO `{#}users` (`id`, `groups`, `email`, `password`, `password_salt`, `is_admin`, `nickname`, `date_reg`, `date_log`, `date_group`, `ip`, `is_locked`, `lock_until`, `lock_reason`, `pass_token`, `date_token`, `files_count`, `friends_count`, `time_zone`, `karma`, `rating`, `theme`, `notify_options`, `privacy_options`, `status_id`, `status_text`, `inviter_id`, `invites_count`, `date_invites`, `birth_date`, `city`, `city_cache`, `hobby`, `avatar`, `icq`, `skype`, `phone`, `music`, `movies`, `site`) VALUES
(1, '---\n- 6\n', 'admin@example.com', '', '', 1, 'admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '127.0.0.1', NULL, NULL, NULL, NULL, NULL, 468, 2, 'Europe/London', 0, 0, '---\nbg_img: null\nbg_color: ''#ffffff''\nbg_repeat: no-repeat\nbg_pos_x: left\nbg_pos_y: top\nmargin_top: 0\n', '---\nusers_friend_add: both\nusers_friend_delete: both\ncomments_new: both\ncomments_reply: email\nusers_friend_aссept: pm\ngroups_invite: email\nusers_wall_write: email\n', '---\nusers_profile_view: anyone\nmessages_pm: anyone\n', NULL, NULL, NULL, 0, NULL, '1985-10-15 00:00:00', 12008, 'London', 'Style too own civil out along. Perfectly offending attempted add arranging age gentleman concluded.', NULL, '987654321', 'admin', '100-20-30', 'Disco House, Minimal techno', 'various interesting', 'instantcms.ru');

DROP TABLE IF EXISTS `{#}users_contacts`;
CREATE TABLE `{#}users_contacts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL COMMENT 'User ID',
  `contact_id` int(11) unsigned DEFAULT NULL COMMENT 'Contact (other user) ID',
  `date_last_msg` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last message date',
  `messages` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Messages count',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`contact_id`),
  KEY `contact_id` (`contact_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User contacts';

DROP TABLE IF EXISTS `{#}users_fields`;
CREATE TABLE `{#}users_fields` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ctype_id` int(11) unsigned DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `hint` varchar(200) DEFAULT NULL,
  `ordering` int(11) unsigned DEFAULT NULL,
  `fieldset` varchar(32) DEFAULT NULL,
  `type` varchar(16) DEFAULT NULL,
  `is_in_list` tinyint(1) unsigned DEFAULT NULL,
  `is_in_item` tinyint(1) unsigned DEFAULT NULL,
  `is_in_filter` tinyint(1) unsigned DEFAULT NULL,
  `is_private` tinyint(1) unsigned DEFAULT NULL,
  `is_fixed` tinyint(1) unsigned DEFAULT NULL,
  `is_fixed_type` tinyint(1) unsigned DEFAULT NULL,
  `is_system` tinyint(1) unsigned DEFAULT NULL,
  `values` text,
  `options` text,
  `groups_read` text,
  `groups_edit` text,
  `filter_view` text,
  PRIMARY KEY (`id`),
  KEY `ordering` (`ordering`),
  KEY `is_in_list` (`is_in_list`),
  KEY `is_in_item` (`is_in_item`),
  KEY `is_in_filter` (`is_in_filter`),
  KEY `is_private` (`is_private`),
  KEY `is_fixed` (`is_fixed`),
  KEY `is_system` (`is_system`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='User profile fields';

INSERT INTO `{#}users_fields` (`id`, `ctype_id`, `name`, `title`, `hint`, `ordering`, `fieldset`, `type`, `is_in_list`, `is_in_item`, `is_in_filter`, `is_private`, `is_fixed`, `is_fixed_type`, `is_system`, `values`, `options`, `groups_read`, `groups_edit`) VALUES
(1, NULL, 'birth_date', 'Age', NULL, 4, 'About', 'age', NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, '---\ndate_title: Date of birth\nshow_y: 1\nshow_m: null\nshow_d: null\nshow_h: null\nshow_i: null\nrange: YEAR\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n'),
(2, NULL, 'city', 'City', 'Select the city where you live', 3, 'About', 'city', NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, '---\nlabel_in_item: left\nis_required: 1\nis_digits: \nis_alphanumeric: \nis_email: \nis_unique: \n', '---\n- 0\n', '---\n- 0\n'),
(3, NULL, 'hobby', 'Tell us about yourself', 'Tell us about your interests and hobbies', 11, 'About me', 'text', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, '---\nmin_length: 0\nmax_length: 255\nis_html_filter: null\nlabel_in_item: none\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n'),
(5, NULL, 'nickname', 'Username', 'Your display name on the website', 1, 'About', 'string', NULL, 1, 1, NULL, 1, NULL, 1, NULL, '---\r\nlabel_in_list: left\r\nlabel_in_item: left\r\nis_required: 1\r\nis_digits: \r\nis_number: \r\nis_alphanumeric: \r\nis_email: \r\nis_unique: \r\nmin_length: 2\r\nmax_length: 64\r\n', '---\n- 0\n', '---\n- 0\n'),
(6, NULL, 'avatar', 'Avatar', 'Your main photo', 2, 'About', 'image', NULL, 1, NULL, NULL, 1, NULL, 1, 'normal | default/avatar.jpg\r\nsmall | default/avatar_small.jpg\r\nmicro | default/avatar_micro.png', '---\nsize_teaser: micro\nsize_full: normal\nsizes:\n  - micro\n  - small\n  - normal\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n'),
(7, NULL, 'icq', 'ICQ', NULL, 8, 'Contacts', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, '---\nmin_length: 0\nmax_length: 9\nlabel_in_item: left\nis_required: null\nis_digits: 1\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n'),
(8, NULL, 'skype', 'Skype', NULL, 9, 'Contacts', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, '---\nmin_length: 0\nmax_length: 32\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n'),
(9, NULL, 'phone', 'Phone number', NULL, 7, 'Contacts', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, '---\nmin_length: 0\nmax_length: 255\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n'),
(10, NULL, 'music', 'Favorite Music', NULL, 6, 'Preferences', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, '---\nmin_length: 0\nmax_length: 255\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n'),
(11, NULL, 'movies', 'Favorite Movies', NULL, 5, 'Preferences', 'string', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, '---\nmin_length: 0\nmax_length: 255\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n'),
(12, NULL, 'site', 'Website', 'Your personal website', 10, 'Contacts', 'url', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, '---\nredirect: 1\nauto_http: 1\nlabel_in_item: left\nis_required: null\nis_digits: null\nis_alphanumeric: null\nis_email: null\n', '---\n- 0\n', '---\n- 0\n');

DROP TABLE IF EXISTS `{#}users_friends`;
CREATE TABLE `{#}users_friends` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL COMMENT 'User ID',
  `friend_id` int(11) unsigned DEFAULT NULL COMMENT 'Friend ID',
  `is_mutual` tinyint(1) unsigned DEFAULT NULL COMMENT 'Is friendship mutual?',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`is_mutual`),
  KEY `friend_id` (`friend_id`,`is_mutual`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Friendship between users';

DROP TABLE IF EXISTS `{#}users_groups`;
CREATE TABLE `{#}users_groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL COMMENT 'System name',
  `title` varchar(32) NOT NULL COMMENT 'Group title',
  `is_fixed` tinyint(1) unsigned DEFAULT NULL COMMENT 'System?',
  `is_public` tinyint(1) unsigned DEFAULT NULL COMMENT 'Choose group upon registration?',
  `is_filter` tinyint(1) unsigned DEFAULT NULL COMMENT 'Show group in the user filter?',
  PRIMARY KEY (`id`),
  KEY `is_fixed` (`is_fixed`),
  KEY `is_public` (`is_public`),
  KEY `is_filter` (`is_filter`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='User groups';

INSERT INTO `{#}users_groups` (`id`, `name`, `title`, `is_fixed`, `is_public`, `is_filter`) VALUES
(1, 'guests', 'Guests', 1, NULL, NULL),
(3, 'newbies', 'Newbies', NULL, NULL, NULL),
(4, 'members', 'Members', NULL, NULL, NULL),
(5, 'moderators', 'Moderators', NULL, NULL, NULL),
(6, 'admins', 'Administrators', NULL, NULL, 1);

DROP TABLE IF EXISTS `{#}users_groups_members`;
CREATE TABLE `{#}users_groups_members` (
  `user_id` int(11) unsigned NOT NULL,
  `group_id` int(11) unsigned NOT NULL,
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Binding users to groups';

INSERT INTO `{#}users_groups_members` (`user_id`, `group_id`) VALUES
(1, 6);

DROP TABLE IF EXISTS `{#}users_groups_migration`;
CREATE TABLE `{#}users_groups_migration` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `is_active` tinyint(1) unsigned DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL,
  `group_from_id` int(11) unsigned DEFAULT NULL,
  `group_to_id` int(11) unsigned DEFAULT NULL,
  `is_keep_group` tinyint(1) unsigned DEFAULT NULL,
  `is_passed` tinyint(1) unsigned DEFAULT NULL,
  `is_rating` tinyint(1) unsigned DEFAULT NULL,
  `is_karma` tinyint(1) unsigned DEFAULT NULL,
  `passed_days` int(11) unsigned DEFAULT NULL,
  `passed_from` tinyint(1) unsigned DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `karma` int(11) DEFAULT NULL,
  `is_notify` tinyint(1) unsigned DEFAULT NULL,
  `notify_text` text,
  PRIMARY KEY (`id`),
  KEY `group_from_id` (`group_from_id`),
  KEY `group_to_id` (`group_to_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Migration rules between groups';

INSERT INTO `{#}users_groups_migration` (`id`, `is_active`, `title`, `group_from_id`, `group_to_id`, `is_keep_group`, `is_passed`, `is_rating`, `is_karma`, `passed_days`, `passed_from`, `rating`, `karma`, `is_notify`, `notify_text`) VALUES
(1, 1, 'Time test', 3, 4, 0, 1, NULL, NULL, 3, 0, NULL, NULL, 1, '3 days elapsed from the moment of your registration.\r\nAll site features are available to you now');

DROP TABLE IF EXISTS `{#}users_ignors`;
CREATE TABLE `{#}users_ignors` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL COMMENT 'User ID',
  `ignored_user_id` int(11) unsigned NOT NULL COMMENT 'Ignored user ID',
  PRIMARY KEY (`id`),
  KEY `ignored_user_id` (`ignored_user_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}users_invites`;
CREATE TABLE `{#}users_invites` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `email` (`email`),
  KEY `key` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}users_karma`;
CREATE TABLE `{#}users_karma` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL COMMENT 'Who voted',
  `profile_id` int(11) unsigned DEFAULT NULL COMMENT 'Vote for',
  `date_pub` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Vote date',
  `points` tinyint(2) DEFAULT NULL COMMENT 'Score',
  `comment` varchar(256) DEFAULT NULL COMMENT 'Comment',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `profile_id` (`profile_id`),
  KEY `date_pub` (`date_pub`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User reputation votes';

DROP TABLE IF EXISTS `{#}users_messages`;
CREATE TABLE `{#}users_messages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `from_id` int(11) unsigned NOT NULL COMMENT 'Sender ID',
  `to_id` int(11) unsigned NOT NULL COMMENT 'Recipient ID',
  `date_pub` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation date',
  `date_delete` timestamp NULL DEFAULT NULL COMMENT 'Delete date',
  `is_new` tinyint(1) unsigned DEFAULT '1' COMMENT 'Unread?',
  `content` text NOT NULL COMMENT 'Message',
  `is_deleted` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `from_id` (`from_id`,`to_id`),
  KEY `to_id` (`to_id`,`is_new`,`is_deleted`),
  KEY `date_delete` (`date_delete`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User private messages';

DROP TABLE IF EXISTS `{#}users_notices`;
CREATE TABLE `{#}users_notices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `date_pub` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `content` text,
  `options` text,
  `actions` text,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `date_pub` (`date_pub`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}users_statuses`;
CREATE TABLE `{#}users_statuses` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL COMMENT 'User',
  `date_pub` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Publication date',
  `content` varchar(140) DEFAULT NULL COMMENT 'Status text',
  `replies_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Number of replies',
  `wall_entry_id` int(11) unsigned DEFAULT NULL COMMENT 'Wall post ID',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `date_pub` (`date_pub`),
  KEY `replies_count` (`replies_count`),
  KEY `wall_entry_id` (`wall_entry_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='User text statuses';

DROP TABLE IF EXISTS `{#}users_tabs`;
CREATE TABLE `{#}users_tabs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(32) DEFAULT NULL,
  `controller` varchar(32) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `is_active` tinyint(1) unsigned DEFAULT NULL,
  `ordering` int(11) unsigned DEFAULT NULL,
  `groups_view` text,
  `groups_hide` text,
  `show_only_owner` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `is_active` (`is_active`,`ordering`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}users_tabs` (`id`, `title`, `controller`, `name`, `is_active`, `ordering`) VALUES
(1, 'Feed', 'activity', 'activity', 1, 1),
(3, 'Friends', 'users', 'friends', 1, 2),
(4, 'Comments', 'comments', 'comments', 1, 4),
(5, 'Groups', 'groups', 'groups', 1, 3),
(6, 'Reputation', 'users', 'karma', 1, 5);

DROP TABLE IF EXISTS `{#}users_personal_settings`;
CREATE TABLE `{#}users_personal_settings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `skey` varchar(150) DEFAULT NULL,
  `settings` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`skey`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `{#}wall_entries`;
CREATE TABLE `{#}wall_entries` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `date_pub` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Publication date',
  `controller` varchar(32) DEFAULT NULL COMMENT 'Profile owner component',
  `profile_type` varchar(32) DEFAULT NULL COMMENT 'Profile type (user/group)',
  `profile_id` int(11) unsigned DEFAULT NULL COMMENT 'Profile ID',
  `user_id` int(11) unsigned DEFAULT NULL COMMENT 'Author ID',
  `parent_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Parent item ID',
  `status_id` int(11) unsigned DEFAULT NULL COMMENT 'User status binding',
  `content` text COMMENT 'Item content',
  `content_html` text COMMENT 'Sanitized text',
  PRIMARY KEY (`id`),
  KEY `date_pub` (`date_pub`),
  KEY `user_id` (`user_id`),
  KEY `parent_id` (`parent_id`),
  KEY `profile_id` (`profile_id`,`profile_type`),
  KEY `status_id` (`status_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Profile wall posts';

DROP TABLE IF EXISTS `{#}widgets`;
CREATE TABLE `{#}widgets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `controller` varchar(32) DEFAULT NULL COMMENT 'Controler',
  `name` varchar(32) NOT NULL COMMENT 'System name',
  `title` varchar(64) DEFAULT NULL COMMENT 'Title',
  `author` varchar(128) DEFAULT NULL COMMENT 'Author name',
  `url` varchar(250) DEFAULT NULL COMMENT 'Author site',
  `version` varchar(8) DEFAULT NULL COMMENT 'Version',
  PRIMARY KEY (`id`),
  KEY `version` (`version`),
  KEY `name` (`name`),
  KEY `controller` (`controller`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}widgets` (`id`, `controller`, `name`, `title`, `author`, `url`, `version`) VALUES
(1, NULL, 'text', 'Text block', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(2, 'users', 'list', 'User list', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(3, NULL, 'menu', 'Menu', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(4, 'content', 'list', 'Content list', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(5, 'content', 'categories', 'Categories', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(6, 'activity', 'list', 'Activity feed', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(7, 'comments', 'list', 'New comments', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(8, 'users', 'online', 'Who is online', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(9, 'users', 'avatar', 'User Avatar', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(10, 'tags', 'cloud', 'Tag cloud', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(11, 'content', 'slider', 'Content slider', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(12, NULL, 'auth', 'Authorization', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(13, 'search', 'search', 'Search', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(14, NULL, 'html', 'HTML block', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(15, 'content', 'filter', 'Content filter', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0'),
(16, 'photos', 'list', 'Photos list', 'InstantCMS Team', 'http://www.instantcms.ru', '2.0');

DROP TABLE IF EXISTS `{#}widgets_bind`;
CREATE TABLE `{#}widgets_bind` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `template` varchar(30) DEFAULT NULL COMMENT 'Template binding',
  `widget_id` int(11) unsigned NOT NULL,
  `title` varchar(128) NOT NULL COMMENT 'Title',
  `links` text,
  `class` varchar(64) DEFAULT NULL COMMENT 'CSS class',
  `class_title` varchar(64) DEFAULT NULL,
  `class_wrap` varchar(64) DEFAULT NULL,
  `is_title` tinyint(1) unsigned DEFAULT '1' COMMENT 'Show title',
  `is_enabled` tinyint(1) unsigned DEFAULT NULL COMMENT 'Enabled?',
  `is_tab_prev` tinyint(1) unsigned DEFAULT NULL COMMENT 'Group with the previous?',
  `groups_view` text COMMENT 'Show to groups',
  `groups_hide` text COMMENT 'Do not show to groups',
  `options` text COMMENT 'Options',
  `page_id` int(11) unsigned DEFAULT NULL COMMENT 'Page ID',
  `position` varchar(32) DEFAULT NULL COMMENT 'Position title ',
  `ordering` int(11) unsigned DEFAULT NULL COMMENT 'Order number',
  `tpl_body` varchar(128) DEFAULT NULL,
  `tpl_wrap` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `position` (`position`),
  KEY `widget_id` (`widget_id`),
  KEY `page_id` (`page_id`,`position`,`ordering`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Site widgets';

INSERT INTO `{#}widgets_bind` (`id`, `template`, `widget_id`, `title`, `links`, `class`, `class_title`, `class_wrap`, `is_title`, `is_enabled`, `is_tab_prev`, `groups_view`, `groups_hide`, `options`, `page_id`, `position`, `ordering`, `tpl_body`, `tpl_wrap`) VALUES
(1, 'default', 3, 'Main menu', NULL, NULL, NULL, NULL, NULL, 1, NULL, '---\n- 0\n', NULL, '---\nmenu: main\nis_detect: 1\nmax_items: 8\n', 0, 'top', 1, NULL, NULL),
(2, 'default', 3, 'Auth menu', NULL, NULL, NULL, NULL, NULL, 1, NULL, '---\n- 1\n', NULL, '---\nmenu: header\nis_detect: 1\nmax_items: 0\n', 0, 'header', 1, NULL, NULL),
(5, 'default', 3, 'Actions menu', NULL, NULL, NULL, 'fixed_actions_menu', NULL, 1, NULL, '---\n- 0\n', NULL, '---\nmenu: toolbar\ntemplate: menu\nis_detect: null\nmax_items: 0\n', 0, 'left-top', 1, 'menu', 'wrapper'),
(20, 'default', 12, 'Log in', NULL, NULL, NULL, NULL, 1, 1, NULL, '---\n- 0\n', NULL, '', 0, 'right-center', 1, NULL, NULL),
(3, 'default', 9, 'User menu', NULL, NULL, NULL, NULL, NULL, 1, NULL, '---\n- 0\n', '---\n- 1\n', '---\nmenu: personal\nis_detect: 1\nmax_items: 0\n', 0, 'header', 3, 'avatar', 'wrapper');

DROP TABLE IF EXISTS `{#}widgets_pages`;
CREATE TABLE `{#}widgets_pages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `controller` varchar(32) DEFAULT NULL COMMENT 'Component',
  `name` varchar(64) DEFAULT NULL COMMENT 'System name',
  `title_const` varchar(64) DEFAULT NULL COMMENT 'Page title (language constant)',
  `title_subject` varchar(64) DEFAULT NULL COMMENT 'Subject title (transferred to the language constant)',
  `title` varchar(64) DEFAULT NULL,
  `url_mask` text COMMENT 'URL mask',
  `url_mask_not` text COMMENT 'Negative mask',
  PRIMARY KEY (`id`),
  KEY `controller` (`controller`),
  KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `{#}widgets_pages` (`id`, `controller`, `name`, `title_const`, `title_subject`, `title`, `url_mask`, `url_mask_not`) VALUES
(100, 'users', 'list', 'LANG_USERS_LIST', NULL, NULL, 'users\r\nusers/index\r\nusers/index/*', NULL),
(101, 'users', 'profile', 'LANG_USERS_PROFILE', NULL, NULL, 'users/%*', NULL),
(102, 'users', 'edit', 'LANG_USERS_EDIT_PROFILE', NULL, NULL, 'users/edit/*', NULL),
(155, 'content', 'albums.all', 'LANG_WP_CONTENT_ALL_PAGES', NULL, NULL, 'albums\nalbums-*\nalbums/*', NULL),
(156, 'content', 'albums.list', 'LANG_WP_CONTENT_LIST', NULL, NULL, 'albums\nalbums-*\nalbums/*', 'albums/*.html\nalbums/add\nalbums/add/%\nalbums/addcat\nalbums/addcat/%\nalbums/editcat/%\nalbums/edit/*'),
(157, 'content', 'albums.item', 'LANG_WP_CONTENT_ITEM', NULL, NULL, 'albums/*.html', NULL),
(158, 'content', 'albums.edit', 'LANG_WP_CONTENT_ITEM_EDIT', NULL, NULL, 'albums/add\nalbums/add/%\nalbums/edit/*', NULL),
(167, 'photos', 'item', 'LANG_PHOTOS_WP_ITEM', NULL, NULL, 'photos/*.html', NULL),
(168, 'photos', 'upload', 'LANG_PHOTOS_WP_UPLOAD', NULL, NULL, 'photos/upload/%\r\nphotos/upload', NULL);