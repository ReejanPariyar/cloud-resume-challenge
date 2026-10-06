import json
import boto3

dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    response = dynamodb.update_item(
        TableName='resume-visitor-count',
        Key={'id': {'S': 'visitors'}},
        UpdateExpression='ADD #c :inc',
        ExpressionAttributeNames={'#c': 'count'},
        ExpressionAttributeValues={':inc': {'N': '1'}},
        ReturnValues='UPDATED_NEW'
    )
    count = int(response['Attributes']['count']['N'])
    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps({'count': count})
    }
