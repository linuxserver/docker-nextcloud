<?php
$CONFIG = array (
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'memcache.distributed' => '\\OC\\Memcache\\Memcached',
  'datadirectory' => '/data',
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/app/www/public/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/app/www/public/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
);
