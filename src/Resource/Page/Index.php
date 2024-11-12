<?php

declare(strict_types=1);

namespace MyVendor\HelloCli\Resource\Page;

use BEAR\Cli\Attribute\Cli;
use BEAR\Cli\Attribute\Option;
use BEAR\Resource\ResourceObject;

class Index extends ResourceObject
{
    /** @var array{greeting: string} */
    public $body;

    #[Cli(
        name: 'hello',
        description: 'Hello World',
        output: 'greeting'
    )]
    public function onGet(
        #[Option(shortName: 'n', description: 'Your name')]
        string $name = 'BEAR.Sunday'): static
    {
        $this->body = [
            'greeting' => 'Hello ' . $name,
        ];

        return $this;
    }
}
