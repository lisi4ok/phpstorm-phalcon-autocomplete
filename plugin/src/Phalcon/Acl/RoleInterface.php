<?php

/* This file is part of the Phalcon Framework.
 *
 * (c) Phalcon Team <team@phalcon.io>
 *
 * For the full copyright and license information, please view the LICENSE.txt
 * file that was distributed with this source code.
 */
namespace Phalcon\Acl;

/**
 * Interface for Phalcon\Acl\Role
 */
interface RoleInterface
{
    /**
     * Returns the role name
     *
     * @return string
     */
    public function getName(): string;

    /**
     * Returns role description
     *
     * @return string
     */
    public function getDescription(): string;

    /**
     * Magic method __toString
     *
     * @return string
     */
    public function __toString(): string;
}
