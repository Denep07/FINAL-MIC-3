<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;

return function (App $app) {
    // Ruta raíz para evitar error 404
    $app->get('/', function (Request $request, Response $response) {
        $response->getBody()->write(json_encode(['message' => 'Microservicio Padres/Tutores activo']));
        return $response->withHeader('Content-Type', 'application/json');
    });
    $container = $app->getContainer();
    $db = $container->get('db');

    // Listar todos los padres/tutores
    $app->get('/padres', function (Request $request, Response $response) use ($db) {
        $stmt = $db->query('SELECT * FROM padres_tutores');
        $padres = $stmt->fetchAll();
        $response->getBody()->write(json_encode($padres));
        return $response->withHeader('Content-Type', 'application/json');
    });

    // Obtener un padre/tutor por ID
    $app->get('/padres/{id}', function (Request $request, Response $response, $args) use ($db) {
        $stmt = $db->prepare('SELECT * FROM padres_tutores WHERE codigo_tutor = ?');
        $stmt->execute([$args['id']]);
        $padre = $stmt->fetch();
        if ($padre) {
            $response->getBody()->write(json_encode($padre));
            return $response->withHeader('Content-Type', 'application/json');
        }
        return $response->withStatus(404);
    });

    // Crear un nuevo padre/tutor
    $app->post('/padres', function (Request $request, Response $response) use ($db) {
        $data = $request->getParsedBody();
        $stmt = $db->prepare('INSERT INTO padres_tutores (nombre_completo, relacion_con_nino, direccion, telefono, correo) VALUES (?, ?, ?, ?, ?)');
        $stmt->execute([
            $data['nombre_completo'],
            $data['relacion_con_nino'],
            $data['direccion'] ?? null,
            $data['telefono'] ?? null,
            $data['correo'] ?? null
        ]);
        $id = $db->lastInsertId();
        $response->getBody()->write(json_encode(['codigo_tutor' => $id]));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    });

    // Actualizar un padre/tutor
    $app->put('/padres/{id}', function (Request $request, Response $response, $args) use ($db) {
        $data = $request->getParsedBody();
        $stmt = $db->prepare('UPDATE padres_tutores SET nombre_completo = ?, relacion_con_nino = ?, direccion = ?, telefono = ?, correo = ? WHERE codigo_tutor = ?');
        $stmt->execute([
            $data['nombre_completo'],
            $data['relacion_con_nino'],
            $data['direccion'] ?? null,
            $data['telefono'] ?? null,
            $data['correo'] ?? null,
            $args['id']
        ]);
        return $response->withStatus(204);
    });

    // Eliminar un padre/tutor
    $app->delete('/padres/{id}', function (Request $request, Response $response, $args) use ($db) {
        $stmt = $db->prepare('DELETE FROM padres_tutores WHERE codigo_tutor = ?');
        $stmt->execute([$args['id']]);
        return $response->withStatus(204);
    });
};
