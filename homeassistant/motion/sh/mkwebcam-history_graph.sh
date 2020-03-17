#!/bin/bash

###
### webcams history_graph
###

LIMITED_BUILD=$(jq -r '.limited?==true' ${1:-webcams.json})

WEBCAMS=$(jq -r '.[].name' ${1:-webcams.json})

## SENSORS
if [ "${LIMITED_BUILD:-null}" != 'true' ]; then
  WEBCAM_EVENTS='detected_entity detected annotated end'
  WEBCAM_ATTRIBUTES='ago counter count percent delay complete'
  WEBCAM_MEASURES='actual mean stdev change'
else
  WEBCAM_EVENTS='detected_entity detected'
  WEBCAM_ATTRIBUTES='ago count percent delay complete'
  WEBCAM_MEASURES='actual mean stdev'
fi

echo "###"
echo "## history_grsph/webcams.yaml"
echo "###"
echo ""

for E in ${WEBCAM_EVENTS}; do
  for A in ${WEBCAM_ATTRIBUTES}; do
    for M in ${WEBCAM_MEASURES}; do
      if [ "${M}" == 'actual' ]; then MM=; else MM="_${M}"; fi
      echo "#"
      echo "motion_${E}_${A}${MM}_webcams:"
      echo "  name: motion_${E}_${A}${MM}_webcams"
      echo "  hours_to_show: 24"
      echo "  refresh: 30"
      echo "  entities:"
      echo "    - sensor.motion_${E}_${A}${MM}"
      for C in ${WEBCAMS}; do
        echo "    - sensor.motion_${E}_${A}_${C}${MM}"
      done
      echo ""
    done
  done
done
