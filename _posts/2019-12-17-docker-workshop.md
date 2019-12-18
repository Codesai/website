---
layout: post
title: "Funny Docker Workshop to learn from scratch"
date: 2019-12-17 22:00:00.000000000 +01:00
type: post
categories:
  - Docker
  - Heroku
  - Learning
  - Workshop
small_image: docker.jpeg
author: Miguel Viera
written_in: english
---

# Introduction

In one of our current clients we are taking some learning time for new things outside of our current context/stack. One of the proposals of the team was a Docker workshop because I introduced it for our CI and our local testing environments to avoid connecting to production from the local machines to run the our tests.

So I was the person in charge to prepare it. And here I would like to share a way to learn Docker from scratch I thought myself.

# Learn by doing

I really believe in the philosophy for learning new things is tighly related with practise, practise, practise... And that's also in Codesai's DNA, so I wanted to ideate a way to explain a bit of theory of Docker and exercises to apply that theory. The theory I explained answers the following:

- The whys:
  - Why Docker?
  - Differences with the past technologies
  - Why is better than the previous tooling?
- The hows:
  - How Docker solve the problem?
  - How Docker improve the previous problem?
  - How Docker can help us?

And the small exercise consist on assembling two different applications with different languages and let people see one of the advantages of Docker. **Removing the complexity of dedicated infrastructure** for a concrete language/stack.

And as the last trick I wanted them to see how easy is to build, push an image and publish your Docker container in a famous service like Heroku. So in the last part of the workshop we do that. The steps explaining how to do publish your app on Heroku can be also found on the README file inside of the *heroku/* folder from the root of the repository.

So I'd like you to check it by yourself and give me some feedback and enjoy what I prepared. **Let's Dockerize everything!!**.

Here is the repository with the content and the exercises. **Each folder has a README.md** explaining what to do. The main README.md is just the theory of Docker. Enjoy! [Docker Workshop Repo](https://github.com/Groxalf/docker-workshop)

