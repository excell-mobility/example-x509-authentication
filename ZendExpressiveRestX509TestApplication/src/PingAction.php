<?php

namespace App;

use Zend\Diactoros\Response;
use Zend\Diactoros\Response\JsonResponse;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

class PingAction
{
    public function __invoke(ServerRequestInterface $request, ResponseInterface $response, callable $next = null)
    {
        $requestParams = $request->getParsedBody();

        // check for "name" parameter
        if (!isset($requestParams['name'])) {
            $errorResponse = new Response\TextResponse('Bad request: "name" parameter is missing!', 400);
            return $errorResponse;
        }

        return new JsonResponse(['ack' => time()]);
    }
}
