<?php

/* This file is part of the Phalcon Framework.
 *
 * (c) Phalcon Team <team@phalcon.io>
 *
 * For the full copyright and license information, please view the LICENSE.txt
 * file that was distributed with this source code.
 */
namespace Phalcon\Session;

/**
 * Phalcon\Session\BagInterface
 *
 * Interface for Phalcon\Session\Bag
 */
interface BagInterface
{
    /**
     * @param string $element
     * @return mixed
     */
    public function __get(string $element);

    /**
     * @param string $element
     * @return bool
     */
    public function __isset(string $element): bool;

    /**
     * @param string $element
     * @param mixed $value
     * @return void
     */
    public function __set(string $element, $value): void;

    /**
     * @param string $element
     * @return void
     */
    public function __unset(string $element): void;

    /**
     * @param array $data
     * @return void
     */
    public function init(array $data = []): void;

    /**
     * @param string $element
     * @param mixed $defaultValue
     * @param string $cast
     * @return mixed
     */
    public function get(string $element, $defaultValue = null, string $cast = null);

    /**
     * @param string $element
     * @param mixed $value
     * @return void
     */
    public function set(string $element, $value): void;

    /**
     * @param string $element
     * @return bool
     */
    public function has(string $element): bool;

    /**
     * @param string $element
     * @return void
     */
    public function remove(string $element): void;

    /**
     * @return void
     */
    public function clear(): void;
}
