#!/user/bin/bash

cd Databases/$db_name
ls -p | grep -v '^\.'
cd ..; cd ..
echo "End of table list."
