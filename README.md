 Docker image used for developing, building, and testing the [COBC software of SpaceTeamSat1](https://github.com/SpaceTeam/STS1_COBC_SW).

* The `linux-x86` folder is used to build an image that can only compile linux-x86 targets, making it much lighter than the full image.
* The `full` folder is used to build an image that can additionally cross-compile for the COBC (=STM32F411).
