import 'package:flutter/material.dart';

class RefreshFutureBuilder<T> extends StatelessWidget {
  final Future<void> Function() _refreshFunction; // 刷新函数
  final Future<T>? Function() _loadFunction; // 加载函数
  final Widget Function(T?) child; // child 现在接收 snapshot.data

  const RefreshFutureBuilder(
      this._refreshFunction,
      this._loadFunction, {
        required this.child,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshFunction, // 处理下拉刷新
      child: FutureBuilder<T>(
        future: _loadFunction(), // 异步加载数据
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 正在等待异步操作完成时显示进度条
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 如果加载出错显示错误信息
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            // 如果加载成功，将数据传递给 child 回调函数
            return child(snapshot.data);
          } else {
            // 如果没有任何数据返回
            return ListView(
              children: const [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text('No data available')),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
