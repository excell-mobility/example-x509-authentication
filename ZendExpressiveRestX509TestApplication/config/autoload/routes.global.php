<?php

use Zend\Expressive\Helper\BodyParams\BodyParamsMiddleware;

return [
    'dependencies' => [
        'invokables' => [

            // Zend specific stuff
            Zend\Expressive\Router\RouterInterface::class => Zend\Expressive\Router\FastRouteRouter::class,

            // helper
            BodyParamsMiddleware::class => BodyParamsMiddleware::class,

            // actions
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
            'path' => '/api/v1.0/hello',
            'middleware' => [
                BodyParamsMiddleware::class,
                App\PingAction::class,
            ],
            'allowed_methods' => ['GET', 'POST'],
        ],
    ],
];
