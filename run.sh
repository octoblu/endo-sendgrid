#!/bin/bash

PORT=8000
ENDO_OCTOBLU_OAUTH_URL='http://oauth.octoblu.dev'
ENDO_SENDGRID_SENDGRID_CALLBACK_URL='http://endo-sendgrid.octoblu.dev:8000'
ENDO_SENDGRID_SENDGRID_AUTH_URL='http://localhost:3000'
ENDO_SENDGRID_SENDGRID_SCHEMA_URL='http://file-downloader.octoblu.com/download?uri=https://github.com/octoblu/endo-sendgrid/releases/download/dev/api-authentication-schema.json'
# ENDO_SENDGRID_SENDGRID_SCHEMA_URL='https://github-cloud.s3.amazonaws.com/releases/61218792/f150ee02-32fd-11e6-9ae0-685076dbbf7a.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAISTNZFOVBIJMK3TQ%2F20160615%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20160615T203655Z&X-Amz-Expires=300&X-Amz-Signature=b26c414c5ac0a10044c4661d9b37ea185c298327c04fb215009c15cab045e44a&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dapi-authentication-schema.json&response-content-type=application%2Foctet-stream'
ENDO_SENDGRID_SERVICE_URL='http://endo-sendgrid.octoblu.dev:8000'
ENDO_SENDGRID_MANAGER_URL='http://endo-manager.octoblu.dev'
APP_OCTOBLU_HOST='http://app.octoblu.dev'
MESHBLU_UUID='59b7d686-65b4-4dd0-b1af-ebd5aa5fcc20'
MESHBLU_TOKEN='f7c9338a15aae6445c6adf46ef7a9cdd3c18c0d0'
MESHBLU_SERVER='meshblu.octoblu.dev'
MESHBLU_PORT=80
MESHBLU_PRIVATE_KEY='MIIEpQIBAAKCAQEAo09/fTNmC1ov57Zv/3CBIfqet1todgnRuatFrce6u0+sQCj44IYBR3kStniFute1y5eDClu6Qj8+ZqtSIl+neWBZB0jLZejI5uQcySuFJY+Ouh9+T+0wrjSeTR08AIRDdzWauFHa0Gvg+wu9mbPT0zPTF1BZqzEuub9RdysaoRT41ucejDcIyFro85xEVppMZhzFcqYfmSlBlESlz5e8eZ8Y8kwTJ7mxfl1SCipX4PN3dFLGgw+W5HC1Lhis/rjWvKfU+kb7skejDHvEQNiqdTnPnOSegUQw3yfxbDXZsAKQzso+z0okeeGLJO2e2tKasc3TE0ZWBdPzOsEy5WuztwIDAQABAoIBAQCQ3t/wl9zpKysd+UgnKI1VMDcF3u+u7oz+kQHx5CExMr9R90a4HggaeDvyZL30/pBFt/VGBhMX23SmrUniNkqhsKepf5j3oWY+9JLYnmOx60SotXFew8GQeBsJu2pT5wDWSlYjNnHOvDRLX6HlLJI3ZFzY7K1u4OVbX22MMk+gHkb5FxYR6/UrFH+2Y9lfF0TQEl7+rKDnh/pRHjgZ4J4n4V2exSIWthCT/I5r71zaFvZZxy0v3Kj4K1jfBl80uQ4n7vcx4lm7NXFMKBGMNS/teljayP//iBm5F6DsAIWEJ2rABj8bPE8JZHAYs08FUMh9eDlwTxrgmUD9LHo8ssXJAoGBAOIeLRHO3kirRll122xx8rBrneRHr5XPTmXzlmINokmPJENxjW4wg9PQs0CegUDYIpu+uf8qD6+BS1bj8mmol6bcDjyNv0+MzLvGZ9F19JCvwqA5xeqz5Ipz5K/GKB1xJ8tbIU24wqy8E+eSdiCO7AAfg21fGB9Qn4GCMoJ2AI2VAoGBALjkeoV1Zkgbl+tEZ8tqCzpHaKsmtgWHCvKyVOEXJeY2UA/H/P8+pD118pcR9J9PAbmjFkaI+ao89ne1c0OeKwCx7qsaklbS5eq0rAH05Ej2xydVMnGXKt2Q9EbykuejUpnp3DW52EFtSQCSN+jbF1ZE8kAmPBsHh7STZAS95nEbAoGAJ5oNXq8Sczu8CHMByQ5z6L4QWyjK8bvrCSQOVIH6yFNPkJhUotXQYMqOemTIUmkINqrCvJPLR3unjEJD9IlYdhrYS3av6OjJ+qEXEbJM8QI3XgSAS0jSYAVIKhjUccOdqpn9TTVsswAFpGscUTt2zda3F/KtsN5X8UCyQ/MSybkCgYEAr/AisrqLcNRpFORMDKHFO1jWPf8hOFNP1LBj2qlnVBCc0NeSZOSb7yw8gwsAB1RsJNUPDmGrihZmxnTw0QhCjW/D2Cf51wrq5BO2lkoNrWy/CCunS7X4gUw9VwHfTvL4WCPUe390TJYM4LFC6J8LLvl+uBJqIaJhvTB//Y8jKL8CgYEAiA3e0MyxshTvLfSPYk9yNe2VuNzCU6b6bLY6y2WoTsh3zbvjHb3l4jQTsRDDjG/YwAOmw/qPVbl5cj62vp9A34oLeDPH6qeB7/2lbns46A+DEHJYeYJRhH0uUhTML/kZ9fqD2iGz7vXso1FwzzIFqflFI/FRrNsUAN4pzorljJU='

main(){
  env \
    PORT="$PORT" \
    ENDO_OCTOBLU_OAUTH_URL="$ENDO_OCTOBLU_OAUTH_URL" \
    ENDO_SENDGRID_SENDGRID_CALLBACK_URL="$ENDO_SENDGRID_SENDGRID_CALLBACK_URL" \
    ENDO_SENDGRID_SENDGRID_AUTH_URL="$ENDO_SENDGRID_SENDGRID_AUTH_URL" \
    ENDO_SENDGRID_SENDGRID_SCHEMA_URL="$ENDO_SENDGRID_SENDGRID_SCHEMA_URL" \
    ENDO_SENDGRID_SERVICE_URL="$ENDO_SENDGRID_SERVICE_URL" \
    ENDO_SENDGRID_MANAGER_URL="$ENDO_SENDGRID_MANAGER_URL" \
    APP_OCTOBLU_HOST="$APP_OCTOBLU_HOST" \
    MESHBLU_UUID="$MESHBLU_UUID" \
    MESHBLU_TOKEN="$MESHBLU_TOKEN" \
    MESHBLU_SERVER="$MESHBLU_SERVER" \
    MESHBLU_PORT="$MESHBLU_PORT" \
    MESHBLU_PRIVATE_KEY="$MESHBLU_PRIVATE_KEY" \
    npm start
}
main $@
