# coding: utf-8
# Bitch start ECS

from huaweicloudsdkcore.auth.credentials import BasicCredentials
from huaweicloudsdkecs.v2.region.ecs_region import EcsRegion
from huaweicloudsdkcore.exceptions import exceptions
from huaweicloudsdkecs.v2 import *

if __name__ == "__main__":
    ak = "RMRRPJQOTSPT2XLTJA6L"
    sk = "6FBNVvL3H3g1c5EDm1PTco7pFgpxnL5cijvv1q9G"

    credentials = BasicCredentials(ak, sk) \

    client = EcsClient.new_builder() \
        .with_credentials(credentials) \
        .with_region(EcsRegion.value_of("cn-east-3")) \
        .build()

    try:
        request = BatchStartServersRequest()
        listServerIdServersOsStart = [
            ServerId(
                id="fe4e2916-cd76-4c83-8641-c5bc76830fd4"
            ),
            ServerId(
                id="467130e0-ec29-4e43-9463-47651abc99a2"
            ),
            ServerId(
                id="3dc1a9bc-5c04-42b5-aa75-d2596121dd58"
            ),
            ServerId(
                id="40326b0a-ee40-468f-9b02-aa6b4e868b7c"
            ),
            ServerId(
                id="fa6271f7-844a-4d7a-89e8-ceba72897733"
            ),
            ServerId(
                id="1574d828-4f99-426c-bb85-05864582acda"
            ),
            ServerId(
                id="d4f73a3f-a446-4156-8c46-5418908cc22a"
            ),
            ServerId(
                id="ec8e3226-d458-4c7b-86ca-8c739b369a9d"
            )
        ]
        osStartBatchStartServersOption = BatchStartServersOption(
            servers=listServerIdServersOsStart
        )
        request.body = BatchStartServersRequestBody(
            os_start=osStartBatchStartServersOption
        )
        response = client.batch_start_servers(request)
        print(response)
    except exceptions.ClientRequestException as e:
        print(e.status_code)
        print(e.request_id)
        print(e.error_code)
        print(e.error_msg)
