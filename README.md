# porg

[![GitHub release badge]][release]
[![GitHub license badge]][license]
[![Contributor Covenant]][Code of Conduct]

**porg**, portmanteau for Project Organizer, is a bash terminal application to
simplify moving between projects and opening them with an IDE.

## :rocket: Installation

We offer a simple installer that enables the `porg` command so you can use it
from anywhere. It is as simple as launching the following command:

```console
curl -s https://raw.githubusercontent.com/inigochoa/porg/master/installer.sh | sudo bash
```

> Once the installation is finished, you are recommended to include an alias to
> the porg binary. If you > don't add it, porg will work but the directory
> change may have unexpected behavior.

## :wrench: Configuration

The settings are stored in the .porg folder inside the user's home. Every time
the porg command is run, the configuration is checked for existence. If it is
not found, a new one will be created.

The structure of the configuration file is as follows:

```text
[BASE]
editor=SELECTED EDITOR

[PROJECTS]
project1=/path/to/project1
project2=/path/to/project2
```

> Although it is possible to modify the settings by hand, we recommend using the
> [available porg options].

## :man_technologist: Usage

### Available options

| Option | Action |
|--------|--------|
| -a     | Add current path to porg as a project |
| -c     | Configure porg |
| -h     | Print help message |
| -l     | List added projects |
| -r     | Remove a project from porg |

## Contributing

Any kind of contribution is appreciated and welcome. We have a guide on how to
contribute to this project in different ways (see [Contributing]). We encourage
you to read it before starting.

### Donate

If you've tried the project and found it useful, consider making a small
donation to its creators.

<a href="https://www.buymeacoffee.com/inigochoa" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/arial-red.png" alt="Buy Me A Coffee"  height="60" width="217">
</a>

[GitHub release badge]: https://img.shields.io/github/v/release/inigochoa/porg?style=flat-square
[release]: https://github.com/inigochoa/porg/releases/latest
[GitHub license badge]: https://img.shields.io/github/license/inigochoa/porg?style=flat-square
[license]: LICENSE.md
[Contributor Covenant]: https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg?style=flat-square
[Code of Conduct]: CODE_OF_CONDUCT.md
[available porg options]: #available-options
[Contributing]: CONTRIBUTING.md
