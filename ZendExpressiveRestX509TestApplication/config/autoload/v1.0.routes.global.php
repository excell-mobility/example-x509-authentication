<?php

use Zend\Expressive\Helper\BodyParams\BodyParamsMiddleware;
use App\Api\v1_0\Hello;

return [
    'dependencies' => [
        'invokables' => [

            // Zend specific stuff
            Zend\Expressive\Router\RouterInterface::class => Zend\Expressive\Router\FastRouteRouter::class,

            // helper
            BodyParamsMiddleware::class => BodyParamsMiddleware::class,

            // actions
            Hello::class => Hello::class
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
                Hello::class
            ],
            'allowed_methods' => ['GET', 'POST'],
        ],
    ],
];
