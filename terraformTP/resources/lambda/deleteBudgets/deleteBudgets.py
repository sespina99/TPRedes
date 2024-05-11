import json
import boto3
import os

def lambda_handler(event, context):
    print(json.dumps(event))
    aws_region = os.environ['REGION']
    dynamodb_table_name = os.environ['DYNAMODB_TABLE_NAME']
    dynamodb = boto3.resource('dynamodb', region_name=aws_region)

    try:
        table = dynamodb.Table(dynamodb_table_name)
        request_body = json.loads(event['body'])
        user_id = event['requestContext']['authorizer']['claims']['sub']

        budget_key = {
            'user_id': user_id,
            'id': request_body.get('id')
        }

        s3_bucket = os.environ['BUCKET_NAME']
        s3_client = boto3.client('s3')
        s3_key = f"{budget_key['user_id']}/{budget_key['id']}.pdf"

        versions = s3_client.list_object_versions(
            Bucket=s3_bucket,
            Prefix=s3_key
        )

        objects_to_delete = [{'Key': s3_key, 'VersionId': version['VersionId']} for version in versions.get('Versions', [])]

        if objects_to_delete:
            s3_client.delete_objects(
                Bucket=s3_bucket,
                Delete={'Objects': objects_to_delete}
            )

        table.delete_item(
            Key=budget_key
        )

        print(f"Budget {budget_key['user_id']} - {budget_key['id']} deleted from DynamoDB table '{dynamodb_table_name}'.")

        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'DELETE, OPTIONS'
            },
            'body': json.dumps(f"Budget {budget_key['id']} deleted successfully from table '{dynamodb_table_name}'.")
        }
    except Exception as e:
        print(f"Error deleting budget from DynamoDB: {str(e)}")

        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'DELETE, OPTIONS'
            },
            'body': json.dumps(f'Error deleting budget from DynamoDB: {str(e)}')
        }
