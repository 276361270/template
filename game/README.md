1. rebar get-deps
2. 去掉cowboy cowboy.app.src 文件中的 ranch 启动依赖项目 在前面的项目中已经启动
3. make 发布文件打包
4. reload 热更新代码
5. 查看启动端口 在发布文件中 etc app.config 查看端口文件
