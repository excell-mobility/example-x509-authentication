<?php

return [
    'dependencies' => [
        'invokables' => [
            Zend\Expressive\Router\RouterInterface::class => Zend\Expressive\Router\FastRouteRouter::class,
            App\PingAction::class => App\PingAction::class,
        ],
        'factories' => [

        ],
    ],

    'routes' => [
        [
            'name' => 'home',
            'path' => '/',
            'middleware' => App\HomePage::class,
            'allowed_methods' => ['GET'],
        ],
        [
            'name' => 'api.ping',
            'path' => '/hello',
            'middleware' => App\PingAction::class,
            'allowed_methods' => ['GET', 'POST'],
        ],
    ],
];
