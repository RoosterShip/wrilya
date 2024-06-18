# DevOps Workflow

We all love the idea of complex CI/CD systems that do everything for you with little to no interaction however that is not exactly how we roll here at Rooster ship.

## CI - Yes

We want to have Github build our packages for us which is cool

## CD - No

The simple fact is we are too small to invest in some fancy CD system.  Currently once a build has been "approved" it will then be manually deployed to the cluster.  This is for 3 reasons:

- CD systems fail sometimes so from my past experience I end just watching the github bot do it's thing anyway.  NOTE:  I totally get the security argument here that by having github do this I don't have to share credientals or bottle on one person but for now that is not a problem.
- Our security posture with SA is not GREAT so I would prefer NOT so share those keys/tokens all over the place.
- We are not ready for final production deployment and when that time comes we will need to rethink our strategy here so let's just keep it simple

## Github

Github will be used to build the packages and upload to GCP.

## GCP

Hosting of registery and running of live service (kubernetes).