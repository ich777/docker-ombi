#!/bin/bash
if [ "$OMBI_REL" == "latest" ]; then
  LAT_V="$(wget -qO- https://api.github.com/repos/Ombi-app/Ombi/releases/latest | jq -r '.name' | sed 's/v//g')"
elif [ "$OMBI_REL" == "develop" ]; then
  LAT_V="$(wget -qO- https://api.github.com/repos/Ombi-app/Ombi/releases | jq -r 'map(select(.prerelease)) | first | .tag_name' | sed 's/v//g')"
else
  echo "---Version manually set to: v$OMBI_REL---"
  LAT_V="$OMBI_REL"
fi

CUR_V="$(find ${DATA_DIR} -name "ombiinstalledv-*" | cut -d '-' -f2)"

if [ -z $LAT_V ]; then
  if [ -z $CUR_V ]; then
    echo "---Can't get latest version of Ombi, putting container into sleep mode!---"
    sleep infinity
  else
    echo "---Can't get latest version of Ombi, falling back to v$CUR_V---"
    LAT_V=$CUR_V
  fi
fi

if [ -f ${DATA_DIR}/Ombi-v$LAT_V.tar.gz ]; then
    rm ${DATA_DIR}/Ombi-v$LAT_V.tar.gz
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
  echo "---Ombi not found, downloading and installing v$LAT_V...---"
  cd ${DATA_DIR}
  if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Ombi-v$LAT_V.tar.gz "https://github.com/Ombi-app/Ombi/releases/download/v${LAT_V}/linux-x64.tar.gz" ; then
    echo "---Successfully downloaded Ombi v$LAT_V---"
  else
    echo "---Something went wrong, can't download Ombi v$LAT_V, putting container into sleep mode!---"
    sleep infinity
  fi
  mkdir ${DATA_DIR}/Ombi
  tar -C ${DATA_DIR}/Ombi -xf ${DATA_DIR}/Ombi-v$LAT_V.tar.gz
  rm ${DATA_DIR}/Ombi-v$LAT_V.tar.gz
  touch ${DATA_DIR}/ombiinstalledv-$LAT_V
elif [ "$CUR_V" != "$LAT_V" ]; then
  echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
  cd ${DATA_DIR}
  if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Ombi-v$LAT_V.tar.gz "https://github.com/Ombi-app/Ombi/releases/download/v${LAT_V}/linux-x64.tar.gz" ; then
    echo "---Successfully downloaded Ombi v$LAT_V---"
  else
    echo "---Something went wrong, can't download Ombi v$LAT_V, putting container into sleep mode!---"
    sleep infinity
  fi
  rm -R ${DATA_DIR}/Ombi ${DATA_DIR}/ombiinstalledv-$CUR_V
  mkdir ${DATA_DIR}/Ombi
  tar -C ${DATA_DIR}/Ombi -xf ${DATA_DIR}/Ombi-v$LAT_V.tar.gz
  rm ${DATA_DIR}/Ombi-v$LAT_V.tar.gz
  touch ${DATA_DIR}/ombiinstalledv-$LAT_V
elif [ "$CUR_V" == "$LAT_V" ]; then
echo "---Ombi v$CUR_V up-to-date---"
fi

echo "---Preparing Server---"
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Ombi---"
cd ${DATA_DIR}/Ombi
${DATA_DIR}/Ombi/Ombi --storage ${DATA_DIR} ${START_PARAMS}