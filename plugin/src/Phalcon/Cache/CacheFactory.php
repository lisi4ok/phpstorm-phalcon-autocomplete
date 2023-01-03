<?php

/* This file is part of the Phalcon Framework.
 *
 * (c) Phalcon Team <team@phalcon.io>
 *
 * For the full copyright and license information, please view the LICENSE.txt
 * file that was distributed with this source code.
 */
namespace Phalcon\Cache;

use Phalcon\Cache\Adapter\AdapterInterface;
use Phalcon\Cache\Cache;
use Phalcon\Cache\Exception\Exception;
use Phalcon\Config\ConfigInterface;
use Phalcon\Factory\AbstractConfigFactory;

/**
 * Creates a new Cache class
 */
class CacheFactory extends AbstractConfigFactory
{
    /**
     * @var AdapterFactory
     */
    protected $adapterFactory;

    /**
     * Constructor
     *
     * @param AdapterFactory $factory
     */
    public function __construct(AdapterFactory $factory)
    {
    }

    /**
     * Factory to create an instance from a Config object
     *
     * @param array $config = [
     *     'adapter' => 'apcu',
     *     'options' => [
     *         'servers' => [
     *             [
     *                 'host' => 'localhost',
     *                 'port' => 11211,
     *                 'weight' => 1,
     *             ]
     *         ],
     *         'host' => '127.0.0.1',
     *         'port' => 6379,
     *         'index' => 0,
     *         'persistent' => false,
     *         'auth' => '',
     *         'socket' => '',
     *         'defaultSerializer' => 'Php',
     *         'lifetime' => 3600,
     *         'serializer' => null,
     *         'prefix' => 'phalcon',
     *         'storageDir' => ''
     *     ]
     * ]
     *
     * @return CacheInterface
     * @throws Exception
     */
    public function load($config): CacheInterface
    {
    }

    /**
     * Constructs a new Cache instance.
     *
     * @param string $name
     * @param array  $options = [
     *      'servers'           => [
     *          [
     *              'host' => 'localhost',
     *              'port' => 11211,
     *              'weight' => 1,
     *          ]
     *      ],
     *      'host'              => '127.0.0.1',
     *      'port'              => 6379,
     *      'index'             => 0,
     *      'persistent'        => false,
     *      'auth'              => '',
     *      'socket'            => '',
     *      'defaultSerializer' => 'Php',
     *      'lifetime'          => 3600,
     *      'serializer'        => null,
     *      'prefix'            => 'phalcon',
     *      'storageDir'        => '',
     * ]
     *
     * @return CacheInterface
     * @throws Exception
     */
    public function newInstance(string $name, array $options = []): CacheInterface
    {
    }

    /**
     * @return string
     */
    protected function getExceptionClass(): string
    {
    }
}
