<?php

/* This file is part of the Phalcon Framework.
 *
 * (c) Phalcon Team <team@phalcon.io>
 *
 * For the full copyright and license information, please view the LICENSE.txt
 * file that was distributed with this source code.
 */
namespace Phalcon\Mvc\Controller;

/**
 * Phalcon\Mvc\Controller\BindModelInterface
 *
 * Interface for Phalcon\Mvc\Controller
 */
interface BindModelInterface
{
    /**
     * Return the model name associated with this controller
     *
     * @return string
     */
    public static function getModelName(): string;
}
