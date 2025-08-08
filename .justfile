# SPDX-FileCopyrightText: 2022-2024 Temple University <kleinweb@temple.edu>
# SPDX-License-Identifier: GPL-3.0-or-later

###: <https://just.systems/man/en/>

set dotenv-load
set dotenv-required

import '.config/common.vars.just'

mod licenses '.config/licenses'
mod release '.config/release'
mod? bookbrainz '.config/bookbrainz'
mod? kinsta '.config/kinsta'
mod? php '.config/php'
mod? portrayal '.config/portrayal'
mod? sso '.config/sso'
mod? tmdb '.config/tmdb'
mod? wp '.config/wp'

mod migrate 'private/migrate'

# Display a list of available tasks as the default command
default:
  @just --choose

build:
   fd -t f '^vite\.config\.' -a -x \
     bash -c 'cd {//} && npm exec vite build'

[doc: "Check for any lint or formatting issues on project files"]
check:
  dotenv-linter check
  biome check {{prj-root}}
  nix run 'github:kleinweb/beams#php-lint-project'
  composer php-cs-fixer -- check
  composer phpcs
  composer phpstan

[doc: "Check for (non-stylistic) linting issues on project files"]
lint:
  biome lint {{prj-root}}
  nix run 'github:kleinweb/beams#php-lint-project'
  composer lint

[doc: "Write *all* formatter+fixer changes to project files"]
fix:
  treefmt
  composer fix

[doc: "Write _safe_ formatter changes to project files"]
fmt:
  treefmt
