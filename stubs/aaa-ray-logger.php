<?php

class RayLoggerHandler
{
    private const ERRORS = [
        E_ERROR => 'Fatal run-time errors.',
        E_WARNING => 'Run-time warnings (non-fatal errors).',
        E_PARSE => 'Compile-time parse errors.',
        E_NOTICE => 'Run-time notices.',
        E_CORE_ERROR => 'Fatal errors that occur during PHP\'s initial startup.',
        E_CORE_WARNING => 'Warnings (non-fatal errors) that occur during PHP\'s initial startup.',
        E_COMPILE_ERROR => 'Fatal compile-time errors.',
        E_COMPILE_WARNING => 'Compile-time warnings (non-fatal errors).',
        E_USER_ERROR => 'User-generated error message.',
        E_USER_WARNING => 'User-generated warning message.',
        E_USER_NOTICE => 'User-generated notice message.',
        E_RECOVERABLE_ERROR => 'Catchable fatal error.',
        E_DEPRECATED => 'Run-time notices.',
        E_USER_DEPRECATED => 'User-generated warning message.',
    ];

    public function __construct()
    {
        set_error_handler([$this, 'handleErrorHandler']);
        register_shutdown_function([$this, 'handleShutdownFunction']);

        if (function_exists('add_filter')) {
            /** 
             * @see \wp_register_fatal_error_handler()
             * @see \WP_Fatal_Error_Handler - 'wp_php_error_args'
             */
            \add_filter('wp_php_error_args', [$this, 'sendErrorOnWpPhpErrorFilter'], 10, 2);
        }
    }

    public function handleErrorHandler(int $errno, string $errstr, ?string $errfile = null, ?int $errline = null, ?array $errcontext = null): bool
    {
        if (defined('HIDE_NON_CRITICAL_ERRORS') && HIDE_NON_CRITICAL_ERRORS) {
            if (defined('HIDE_NON_CRITICAL_ERRORS_FROM_LOG')) {
                return HIDE_NON_CRITICAL_ERRORS_FROM_LOG;
            }

            return true;
        }

        $this->logPhpError([
            'type' => $errno,
            'message' => $errstr,
            'file' => $errfile,
            'line' => $errline,
            'context' => $errcontext,
        ], 'orange');

        return defined('HIDE_NON_CRITICAL_ERRORS_FROM_LOG') && HIDE_NON_CRITICAL_ERRORS_FROM_LOG;
    }

    public function handleShutdownFunction(): void
    {
        $lastError = error_get_last();

        if ($lastError === null) {
            return;
        }

        $errorTypesToHandle = [E_ERROR, E_PARSE, E_USER_ERROR, E_COMPILE_ERROR, E_RECOVERABLE_ERROR];

        if (empty($lastError['type']) || ! in_array($lastError['type'], $errorTypesToHandle, true)) {
            return;
        }

        $this->logPhpError($lastError, 'red');
    }

    public function sendErrorOnWpPhpErrorFilter(array $args, array $error): array
    {
        $this->logPhpError($error, 'red');

        return $args;
    }

    private function logPhpError(array $error, string $color)
    {
        if (! empty(static::ERRORS[$error['type']])) {
            $err = static::ERRORS[$error['type']];
            $err .= " ({$error['type']})";
        } else {
            $err = $error['type'];
        }
        
        $errstrs = '';
        $splittedErrstr = explode('Stack trace:', $error['message']);
        foreach ($splittedErrstr as $key => $errstr) {
            if ($key === 0) {
                $errstrs .= $errstr;
                continue;
            }

            $aa = explode('Next ', $errstr);

            if (empty($aa[1])) {
                continue;
            }

            $errstrs .= '<hr style="margin: 12px 0" />' . $aa[1];
        }

        $markup = '<table>';
        $markup .= '<tr>';
        $markup .= '<td style="padding: 12px 0 12px 12px; border-bottom: 2px solid grey;"><strong>Error type</strong></td>';
        $markup .= "<td style='padding: 12px 0; border-bottom: 2px solid grey;'>{$err}</td>";
        $markup .= '</tr>';
        $markup .= '<tr>';
        $markup .= '<td style="padding: 12px 0 12px 12px; border-bottom: 2px solid grey;"><strong>Error message(s)</strong></td>';
        $markup .= "<td style='padding: 12px 0; border-bottom: 2px solid grey;'>{$errstrs}</td>";
        $markup .= '</tr>';
        $markup .= '<tr>';
        $markup .= '<td style="padding: 12px 0 12px 12px;"><strong>File (Line)</strong></td>';
        $markup .= "<td style='padding: 12px 0;'><a style='color: #0073aa;' href='{$error['file']}'>{$error['file']}:{$error['line']}</a></td>";
        $markup .= '</tr>';

        if (! empty($error['context'])) {
            $markup .= '<tr>';
            $markup .= '<td style="padding: 12px 0 12px 12px; border-top: 2px solid grey;"><strong>Context</strong></td>';
            $markup .= "<td style='padding: 12px 0; border-top: 2px solid grey;'>{$error['context']}</td>";
            $markup .= '</tr>';
        }

        $markup .= '</table>';

        ray()->html($markup)->label($err)->{$color}();
        ray()->backtrace()->hide()->label('Backtrade for ↑')->{$color}();
        ray()->showApp();
    }
}

if (! defined('HIDE_NON_CRITICAL_ERRORS')) {
    define( 'HIDE_NON_CRITICAL_ERRORS', true );
}
if (! defined('HIDE_NON_CRITICAL_ERRORS_FROM_LOG')) {
    define( 'HIDE_NON_CRITICAL_ERRORS_FROM_LOG', false );
}

new RayLoggerHandler();