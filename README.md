Quest Web
=========

A server offering questions and validating answers.

The task is to convert [quest](https://github.com/municz/quest) tool to
client-server architecture.

Instruction
-----------

### 1. Setting up the environment:

```
bundle install
```

### 2. running a server (by default on http://localhost:9292)

```
rackup
```

### 3. running a client

```
./quest.rb
```
You should get an error saying

```
Exit code 404 (RuntimeError)
```
### 4. TASK: implement Web API for offering questions and validating answers

The client request for a question. The question has id, question and
possible answers. When user selects the desired options, the client
will send it to the server to validate the results.

JSON will be used as a format for the messages.

The questions will be offered randomly.

Sample request for a question:
```
GET /question

200
{
    "id": 1,
    "question": "What's the naming convention for local variables?",
    "answers": [
        "`userDetails`",
        "`user_details`",
        "`UserDetails`",
        "`USER_DETAILS`"
    ]
}
```

Samle request for answers verification:
```
POST /answer
{
    "id": 1,
    "answers": [
        "`user_details`",
    ]
}

200
{ "correct": true }
```

For getting the data use a part of the code of
[the quest repository](https://github.com/municz/quest)
