cat=${1:-hm}
id=${2:-$(date | md5sum)}
id=`echo $id | awk '{print $1}'`

echo $cat/$id >> stories/timeline
mkdir -p stories/$cat
echo "title = \"\"

body" > stories/$cat/$id

git add stories/timeline stories/$cat/$id
