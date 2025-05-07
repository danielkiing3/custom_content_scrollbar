import 'package:custom_content_scrollbar/models/article.dart';
import 'package:custom_content_scrollbar/models/article_subcontent.dart';

const Article dummyArticle = Article(
  title: 'Why even intercept?',
  author: 'Daniel Olayinka',
  articleTime: Duration(minutes: 3),
  subContent: <ArticleSubcontent>[
    ArticleSubcontent(
      heading: 'The What',
      body: '''
Interceptors are kind of like middleware. They sit between your API requests leaving the app and the server response entering, but they are more than that, they are like checkpoints.

They are the last stop before your request goes to talk to the server, checking if the request has what it needs? if the token is valid? is the header attached? and all that.
      ''',
    ),
    ArticleSubcontent(
      heading: 'The Why',
      body: '''
There are so many reason we might want to intercept and use our middleman magic, but let’s keep things focused in what really matters: THE USER.

Okay, take a moment and think about when a app breaks, but not in a full crash kind of way, but in those small, annoying moments that chip away at high bar of user experience we have set. That's where interceptors might really shines.
      ''',
    ),
    ArticleSubcontent(
      heading: 'Network Drops for a Second, Then What?',
      body: '''
Let’s say User A is interacting with your app, navigating around, and suddenly their network drop. Just a flicker or make even a long drop. They try to open a product page, which sends an API request to your server.

This is where interceptors comes in.
Instead of that error bubbling up to the user, the interceptor “intercept😉” it.
      ''',
    ),
    ArticleSubcontent(
      heading: 'Different Apps, Different Interceptors',
      body: '''
These are just a few examples, as you think more critically about your user journey and experience, you will spot more use case. 

Maybe your server has rate limits, intercept, wait, retry, Maybe your app is offline first or you build for a primarily low network zone, intercept, queue requests locally, sync later
      ''',
    ),
    ArticleSubcontent(
      heading: 'Okay,  Let get our hands dirty',
      body: '''
In today’s world, a lot of application communicate to some degree with a remote server in one way or the other - usually through HTTP. 

If your app is constantly making API request,byou want your users to have a solid experience even when the network isn’t, propagate as little error as possible during their lifecycle of using the app and giving the feeling of “things just work”.

So we will be looking at this mostly from a user experience perceptive. What are users expecting when they interact with our app?
      ''',
    ),
  ],
);
