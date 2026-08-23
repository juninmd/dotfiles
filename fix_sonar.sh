#!/bin/bash
# sonarcloud fixes
sed -i '1s|^#!/usr/bin/env bash$|#!/bin/bash|' programas/tere/setup.sh
sed -i '1s|^#!/usr/bin/env bash$|#!/bin/bash|' programas/kubent/setup.sh
sed -i '1s|^#!/usr/bin/env bash$|#!/bin/bash|' programas/litecli/setup.sh
sed -i '1s|^#!/usr/bin/env bash$|#!/bin/bash|' programas/mycli/setup.sh
sed -i '1s|^#!/usr/bin/env bash$|#!/bin/bash|' programas/pgcli/setup.sh
sed -i '1s|^#!/usr/bin/env bash$|#!/bin/bash|' programas/gptme/setup.sh
sed -i '1s|^#!/usr/bin/env bash$|#!/bin/bash|' programas/lazyvim/setup.sh
sed -i '1s|^#!/usr/bin/env bash$|#!/bin/bash|' programas/oh-my-posh/setup.sh
