import '../models/article.dart';
import '../models/article_subcontent.dart';

const Article dummyArticle = Article(
  title: 'Why even intercept?',
  author: 'Daniel Olayinka',
  articleTime: Duration(minutes: 3, seconds: 34),
  subContent: <ArticleSubcontent>[
    ArticleSubcontent(
      heading: 'The What',
      body: '''
Interceptors are kind of like a security checkpoint. They sit between your API requests leaving the app and the server response entering.

They are the last stop before your request goes to talk to the server, checking if the request has what it needs, if the authentication token is valid, is the header attached, and all that. When the API returns a response or an error get thrown, our handy interceptors can come again. Should we reshape the response? Should we retry the failed authorization? Should we even catch the error at all? All this conversation happens here.

Now that we know what interceptors are, let’s discuss “why” we might need them and how does this elevate the user’s experience.
      ''',
    ),
    ArticleSubcontent(
      heading: 'The Why',
      body: '''
There are so many reasons we might want to intercept and use our middleman magic, but let’s keep things focused on what really matters: THE USER.

Okay, take a moment and think about when an app breaks, but not in a full crash kind of way, but in those small, annoying moments that chip away at the high bar of user experience we have set. That’s where interceptors might really shine.

Interceptors are like smoothing over those cracks, those little failure points that would otherwise create friction. Let’s walk through some examples where interceptors could level up the experience
      ''',
    ),
    ArticleSubcontent(
      heading: 'Network Drops for a Second, Then What?',
      body: '''
Let’s say User A is interacting with your app, navigating around, and suddenly their network drops. Just a flicker or maybe even a long dropout. They try to open a product page, which sends an API request to your server. But since they’re offline for that split second, the request fails, and errors get propagated to the user.

At this point, the question isn’t just “What failed?” It’s “What could we have done better as engineers?”, “where did something go wrong and how can we offer a better UX (User Experience)?”

The error intercepted contains all the data about what went wrong and why, so we check: is this a SocketException? (which usually means no internet connection). If yes, we don’t immediately fail. We wait.

You can set up a system that listens for when the connection is restored and the moment it is, retries the request. Quietly, without the user ever knowing a thing.
      ''',
    ),
    ArticleSubcontent(
      heading: 'Token Expired, But We Handle It',
      body: '''
Let’s look at another common use case: an authentication token

Most APIs have some kind of security layer to guard who can access which content by providing users with a token(basically a digital ID card). It gets attached with every request so the server can validate you are who you claim to be.

But tokens expire.

When that happens, the next request gets hit with a 401 Unauthorized. Without interceptors, the request just fails and maybe even results in logging out the user.

You catch that ‘401’, realize the token has expired and use a stored refresh-token to get a new one. Then, here’s the magic: you retry the original request as if nothing happened. No “please log in again”, none of that. No confusion. User is happy
      ''',
    ),
    ArticleSubcontent(
      heading: 'Different Apps, Different Interceptors',
      body: '''
These are just a few examples, as you think more critically about your user journey and experience, you will spot more use cases.

Maybe your server has rate limits, intercept, wait and retry

Maybe your app is offline-first or you’re building for a primarily low-network zones, intercept, queue requests locally and sync later

My point: different APIs behave differently. Your intercepting strategy should serve your user needs.
      ''',
    ),
    ArticleSubcontent(
      heading: 'Okay,  Let get our hands dirty',
      body: '''
In today’s world, a lot of application communicate to some degree with a remote server in one way or the other - usually through HTTP. 

If your app is constantly making API request,byou want your users to have a solid experience even when the network isn’t, propagate as little error as possible during their lifecycle of using the app and giving the feeling of “things just work”.

So we will be looking at this mostly from a user experience perceptive. What are users expecting when they interact with our app?
In today’s world, a lot of application communicate to some degree with a remote server in one way or the other - usually through HTTP. 
If your app is constantly making API request,byou want your users to have a solid experience even when the network isn’t, propagate as little error as possible during their lifecycle of using the app and giving the feeling of “things just work”.
So we will be looking at this mostly from a user experience perceptive. What are users expecting when they interact with our app?
      ''',
    ),
    ArticleSubcontent(
      heading: 'Different Apps, Different Interceptors',
      body: '''
These are just a few examples, as you think more critically about your user journey and experience, you will spot more use cases.

Maybe your server has rate limits, intercept, wait and retry

Maybe your app is offline-first or you’re building for a primarily low-network zones, intercept, queue requests locally and sync later

My point: different APIs behave differently. Your intercepting strategy should serve your user needs.
      ''',
    ),
    ArticleSubcontent(
      heading: 'Network Drops for a Second, Then What?',
      body: '''
Let’s say User A is interacting with your app, navigating around, and suddenly their network drops. Just a flicker or maybe even a long dropout. They try to open a product page, which sends an API request to your server. But since they’re offline for that split second, the request fails, and errors get propagated to the user.

At this point, the question isn’t just “What failed?” It’s “What could we have done better as engineers?”, “where did something go wrong and how can we offer a better UX (User Experience)?”

The error intercepted contains all the data about what went wrong and why, so we check: is this a SocketException? (which usually means no internet connection). If yes, we don’t immediately fail. We wait.

You can set up a system that listens for when the connection is restored and the moment it is, retries the request. Quietly, without the user ever knowing a thing.
      ''',
    ),
  ],
);
