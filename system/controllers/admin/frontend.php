<?php
class admin extends cmsFrontend {

    protected $useOptions = true;

    const perpage = 30;

    public $installer_upload_path = 'installer';

//============================================================================//
//============================================================================//

    public function before($action_name) {

        if (!cmsUser::isAdmin()) { cmsCore::error404(); }

        if(!$this->isAllowByIp()){ cmsCore::error404(); }

        parent::before($action_name);

        $this->cms_template->setLayout('admin');

        $this->cms_template->setMenuItems('cp_main', $this->getAdminMenu());

    }

    private function isAllowByIp() {

        $allow_ips = cmsConfig::get('allow_ips');
        if(!$allow_ips){ return true; }

        return string_in_mask_list(cmsUser::getIp(), $allow_ips);

    }

//============================================================================//
//============================================================================//

    public function getAdminMenu(){

        return cmsEventsManager::hook('adminpanel_menu', array(

            array(
                'title' => LANG_CP_SECTION_CONTENT,
                'url' => href_to($this->name, 'content'),
                'options' => array(
                    'class' => 'item-content'
                )
            ),
            array(
                'title' => LANG_CP_SECTION_CTYPES,
                'url' => href_to($this->name, 'ctypes'),
                'options' => array(
                    'class' => 'item-ctypes'
                )
            ),
            array(
                'title' => LANG_CP_SECTION_MENU,
                'url' => href_to($this->name, 'menu'),
                'options' => array(
                    'class' => 'item-menu'
                )
            ),
            array(
                'title' => LANG_CP_SECTION_WIDGETS,
                'url' => href_to($this->name, 'widgets'),
                'options' => array(
                    'class' => 'item-widgets'
                )
            ),
            array(
                'title' => LANG_CP_SECTION_CONTROLLERS,
                'url' => href_to($this->name, 'controllers'),
                'options' => array(
                    'class' => 'item-controllers'
                )
            ),
            array(
                'title' => LANG_CP_SECTION_USERS,
                'url' => href_to($this->name, 'users'),
                'options' => array(
                    'class' => 'item-users'
                )
            ),
            array(
                'title' => LANG_CP_SECTION_SETTINGS,
                'url' => href_to($this->name, 'settings'),
                'options' => array(
                    'class' => 'item-settings'
                )
            )

        ));

    }

//============================================================================//
//============================================================================//

    public function getCtypeMenu($do='add', $id=null){

        $ctype_menu = array(

            array(
                'title' => LANG_CP_CTYPE_SETTINGS,
                'url' => href_to($this->name, 'ctypes', ($do == 'add' ? array('add') : array('edit', $id)))
            ),
            array(
                'title' => LANG_CP_CTYPE_LABELS,
                'url' => href_to($this->name, 'ctypes', array('labels', $id)),
                'disabled' => ($do == 'add')
            ),
            array(
                'title' => LANG_CP_CTYPE_FIELDS,
                'url' => href_to($this->name, 'ctypes', array('fields', $id)),
                'disabled' => ($do == 'add')
            ),
            array(
                'title' => LANG_CP_CTYPE_PROPS,
                'url' => href_to($this->name, 'ctypes', array('props', $id)),
                'disabled' => ($do == 'add')
            ),
            array(
                'title' => LANG_CP_CTYPE_PERMISSIONS,
                'url' => href_to($this->name, 'ctypes', array('perms', $id)),
                'disabled' => ($do == 'add')
            ),
            array(
                'title' => LANG_CP_CTYPE_DATASETS,
                'url' => href_to($this->name, 'ctypes', array('datasets', $id)),
                'disabled' => ($do == 'add')
            ),
            array(
                'title' => LANG_MODERATORS,
                'url' => href_to($this->name, 'ctypes', array('moderators', $id)),
                'disabled' => ($do == 'add')
            )

        );

        list($ctype_menu, $do, $id) = cmsEventsManager::hook('admin_ctype_menu', array($ctype_menu, $do, $id));

        if($do == 'edit'){

            $ctype = cmsCore::getModel('content')->getContentType($id);

            list($ctype_menu, $ctype) = cmsEventsManager::hook('admin_'.$ctype['name'].'_ctype_menu', array($ctype_menu, $ctype));

        }

        return $ctype_menu;

    }

//============================================================================//
//============================================================================//

    public function getSettingsMenu(){

        return cmsEventsManager::hook('admin_settings_menu', array(

            array(
                'title' => LANG_BASIC_OPTIONS,
                'url' => href_to($this->name, 'settings')
            ),
            array(
                'title' => LANG_CP_SCHEDULER,
                'url' => href_to($this->name, 'settings', array('scheduler'))
            ),

        ));

    }

//============================================================================//
//============================================================================//

    public function loadControllerBackend($controller_name, $request){

        $ctrl_file = $this->cms_config->root_path . 'system/controllers/'.$controller_name.'/backend.php';

        if(!file_exists($ctrl_file)){
            cmsCore::error(sprintf(LANG_CP_ERR_BACKEND_NOT_FOUND, $controller_name));
        }

        include_once($ctrl_file);

        $controller_class = 'backend'.ucfirst($controller_name);

        $backend = new $controller_class($request);

        // Устанавливаем корень для URL внутри бакенда
        $backend->setRootURL($this->name.'/controllers/edit/'.$controller_name);

        return $backend;

    }

//============================================================================//
//============================================================================//

    public function parsePackageManifest(){

        $path = $this->cms_config->upload_path . $this->installer_upload_path;

        $ini_file = $path . '/' . "manifest.{$this->cms_config->language}.ini";
        $ini_file_default = $path . '/' . "manifest.ru.ini";

        if (!file_exists($ini_file)){ $ini_file = $ini_file_default; }
        if (!file_exists($ini_file)){ return false; }

        $manifest = parse_ini_file($ini_file, true);

        if (file_exists($this->cms_config->upload_path . $this->installer_upload_path . '/' . 'package')){
            $manifest['contents'] = $this->getPackageContentsList();
            if($manifest['contents']){
                if(!empty($manifest['contents']['system']['core'])){
                    foreach ($manifest['contents']['system']['core'] as $file) {
                        if(file_exists($this->cms_config->root_path . 'system/core/'.$file)){
                            $manifest['notice_system_files'] = LANG_INSTALL_NOTICE_SYSTEM_FILE;
                            break;
                        }
                    }
                }
                if(!empty($manifest['contents']['system']['config'])){
                    foreach ($manifest['contents']['system']['config'] as $file) {
                        if(file_exists($this->cms_config->root_path . 'system/config/'.$file)){
                            $manifest['notice_system_files'] = LANG_INSTALL_NOTICE_SYSTEM_FILE;
                            break;
                        }
                    }
                }
            }
        } else {
			$manifest['contents'] = false;
		}

        if (isset($manifest['info']['image'])){
            $manifest['info']['image'] = $this->cms_config->upload_host . '/' .
                                            $this->installer_upload_path . '/' .
                                            $manifest['info']['image'];
        }

        if((isset($manifest['install']) || isset($manifest['update']))){

            $action = (isset($manifest['install']) ? 'install' : 'update');

            if(isset($manifest[$action]['type']) && isset($manifest[$action]['name'])){

                $manifest['package'] = array(
                    'type'       => $manifest[$action]['type'],
                    'type_hint'  => constant('LANG_CP_PACKAGE_TYPE_'.strtoupper($manifest[$action]['type']).'_'.strtoupper($action)),
                    'action'     => $action,
                    'name'       => $manifest[$action]['name'],
                    'controller' => (isset($manifest[$action]['controller']) ? $manifest[$action]['controller'] : null),
                );

                // проверяем установленную версию
                $manifest['package']['installed_version'] = call_user_func(array($this, $manifest[$action]['type'].'Installed'), $manifest['package']);

            }

        }

        return $manifest;

    }

    public function componentInstalled($manifest_package) {

        $model = new cmsModel();

        return $model->filterEqual('name', $manifest_package['name'])->getFieldFiltered('controllers', 'version');

    }

    public function widgetInstalled($manifest_package) {

        $model = new cmsModel();

        return $model->filterEqual('name', $manifest_package['name'])->
                filterEqual('controller', $manifest_package['controller'])->
                getFieldFiltered('widgets', 'version');

    }

    private function systemInstalled($manifest_package) {
        return cmsCore::getVersion();
    }

    private function getPackageContentsList(){

        $path = $this->cms_config->upload_path . $this->installer_upload_path . '/' . 'package';

        if (!is_dir($path)) { return false; }

        return files_tree_to_array($path);

    }

}
