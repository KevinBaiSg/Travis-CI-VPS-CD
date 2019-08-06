# 说明
本人之前就借助免费的 Github 和 Travis CI 实现 CI 的功能，但是一直没有关注 CD 部分，
毕竟觉得个人的项目不需要这样的要求，但是最近想着把这部分功能实现，其实也是可以省下不少时间。

# 思路    
**Github---->Travis-ci---->VPS**  
前边部分官方已经提供了完好的解决方案，我们只需要把第二部分配置通过即可。其实第二部分的主要思路就是让 
Travis-ci 使用ssl登录到我们的 VPS 中部署好服务。  
当然这面临到一个问题，Travis-ci 怎么来访问 VPS, 就是借助 ssl 登录。但是这会引申到另一个问题，怎么
解决ssl登录秘钥的问题。本例中，使用到了travis的一个工具。    

```bash
$ brew install travis 
$ travis login --auto 
$ travis encrypt-file ~/.ssh/org.travis-ci --add 
```

通过上述指令安装了 travis，并且登录到 travis-ci账户中，然后使用encrypt-file工具加密了之前配置好秘钥。         

`关于org.travis-ci是登录vps的秘钥，这部分大家可以网上查找相关于ssh登录的部分`

参照本例的 .travis.yaml 文件：

```yaml
before_install:
  - openssl aes-256-cbc -K $encrypted_c35b3785930d_key -iv $encrypted_c35b3785930d_iv
        -in org.travis-ci.enc -out ~/.ssh/org.travis-ci -d
  - chmod 600 ~/.ssh/org.travis-ci
  - echo -e "Host $DEPLOY_ADDRESS\n\tHostName $DEPLOY_ADDRESS\n\t
        StrictHostKeyChecking no\n\tIdentityFile ~/.ssh/org.travis-ci" >> ~/.ssh/config
```
这部分的功能其实就是解密之前加密的 `org.travis-ci` 文件，放置到 .ssh 目录下，
并且设置文件属性，然后配置 .ssh/config 文件。如果配置过ssl登录的人一看就应该明白，只不过现在使用了脚本的形式。

看到这里大家应该也意识到了 org.travis-ci.enc 文件需要上传到 github 中，但是 org.travis-ci 文件是不需要的，
这个文件是访问vps的秘钥文件，不能公开。

再看：
```yaml
after_success:
  - scp -o stricthostkeychecking=no -r travis-vps-test
      $DEPLOY_USERNAME@$DEPLOY_ADDRESS:~/travis-vps-test/
  - ssh -tt $DEPLOY_USERNAME@$DEPLOY_ADDRESS < run.sh
```
在 `after_success` 处其实就是 ssl 登录到服务器中部署服务了。
