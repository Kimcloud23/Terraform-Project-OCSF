// Lambda is responsible for processing my feedback form online.
const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();
exports.handler = async (event) => {
  try {
    const requestBody = JSON.parse(event.body);

    // Extract data from the request
    const name = requestBody.name;
    const email = requestBody.email;
    const feedback = requestBody.feedback;


    // Store the data in DynamoDB
    const params = {
      TableName: 'FeedbackTable',
      Item: {
        FEEDBACKDB: feedback,
        Name: name,
        Email: email,
        Feedback: feedback
      }
    };

    await dynamodb.put(params).promise();
    if (event.httpMethod=== 'POST'){
          return {
            statusCode: 200,
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'OPTIONS, POST, GET, PUT, DELETE',
              'Access-Control-Allow-Headers': '*',
              'Access-Control-Expose-Headers': '*',
            },

      body: JSON.stringify({ message: 'Data sent to FeedbackTable successfully' })
    };
  }
} 
  catch (error) {
    console.error('Error storing feedback:', error);
    return {
      statusCode: 500,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Origin, X-Requested-With, Content-Type, Accept',
      },
      body: JSON.stringify({ message: 'Error submitting feedback. Please try again.' })
    };
  }

};
// lambda test configuration
// {
//   "body": "{\"name\":\"John Doe\",\"email\":\"john@example.com\",\"feedback\":\"Great work!\"}",
//   "httpMethod": "POST"
// }
