<?php
$CONFIG = [
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'memcache.distributed' => '\\OC\\Memcache\\Memcached',
  'datadirectory' => '/data',
  'apps_paths' => [
    0 => [
      'path' => '/app/www/public/apps',
      'url' => '/apps',
      'writable' => false,
    ],
    1 => [
      'path' => '/app/www/public/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ],
  ],
];
