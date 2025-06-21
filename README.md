# test-github-workflow
Step-1 setting up jfrog artifactory.
https:///artifactory/api/docker/demo-docker



#to read
1. read about the settings.xml . check how the dependecies are going to virtual , how cached in local etc. how is the settings.xml configured with these
2. read about shell scripting.
3. Read about docker buildx.

#learning
1. mkdir -p = means to create a complex directory structure..
    suppose: mkdir demo/java/hello.java - error no such file or directory present
              mkdir -p demo/java/hello.java = -p will create the directory structure if it is not present already.
2.  mvn clean compile test package -B = will download dependnecy in non intereactive way. which doesnt need human intervention
    Skip the prompt ,Or fail fast ,
3. echo $artifactory_password | docker login ${docker.registry} -u ${docker.username} --password-stdin
    a. why? because docker login ${docker.registry} -u ${docker.username} --password ${docker.password} -> will print in the logs.
    b. instead take the password from the stdin instead of cmd line. so in the original statement it takes from stdin printed by the stdout.
4. docker build . -> assumes the docker file is present at project root.


caching maven dependencies  - making use of github caching service.

<h3>makes use of hask key to identify the cache. The content of the pom.xml is the hash key.
if it changes then new hash key. leading to cache miss. but the restore key option will 
restore the latest cached dependencies and will download the additional from jfrog</h3>

Run 1: Fresh project
   ├── Downloads: spring-boot, junit, etc. (100 deps) - 3 minutes
   └── Cache Key: ubuntu-maven-hash123

Run 2: No changes
├── Cache Hit: Restores all deps - 30 seconds
└── Cache Key: ubuntu-maven-hash123

Run 3: Added lombok + validation deps  
├── Cache Miss: hash123 → hash456
├── Restore Keys: Gets previous cache (98 deps)
├── Downloads: Only lombok + validation (2 deps) - 45 seconds
└── Cache Key: ubuntu-maven-hash456