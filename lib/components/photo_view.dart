import 'package:cached_network_image/cached_network_image.dart';
import 'package:emotion/components/color.dart';
import 'package:flutter/material.dart'; // Import package
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view_gallery.dart';

typedef PageChanged = void Function(int index);

class PhotoPreview extends StatefulWidget {
  final List galleryItems; //图片列表
  final int defaultImage; //默认第几张
  final PageChanged? pageChanged; //切换图片回调
  final Axis direction; //图片查看方向
  final Decoration? decoration; //背景设计
  final String? desc; //图片描述
  final String? title; //图片描述标题
  final String commentId; //评论ID

  PhotoPreview(
      {required this.galleryItems,
      required this.commentId,
      this.defaultImage = 1,
      this.pageChanged,
      this.direction = Axis.horizontal,
      this.desc,
      this.title,
      this.decoration})
      : assert(galleryItems != null);
  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  int? tempSelect;
  PageController? _pageController;
  @override
  void initState() {
    _pageController = new PageController(initialPage: widget.defaultImage);
    tempSelect = widget.defaultImage + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: em_black,
      body: Stack(
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              onLongPress: () {},
              child: PhotoViewGallery.builder(
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: em_black,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: em_white,
                              strokeWidth: 2.5,
                            ),
                          ),
                          Container(width: 10),
                          Text(
                            "加载图片中…",
                            style: TextStyle(color: em_white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    minScale: PhotoViewComputedScale.contained * 1,
                    heroAttributes: PhotoViewHeroAttributes(
                      tag: widget.galleryItems[index] + widget.commentId,
                    ),
                    imageProvider: CachedNetworkImageProvider(
                      widget.galleryItems[index],
                    ),
                  );
                },
                scrollDirection: widget.direction,
                itemCount: widget.galleryItems.length,
                pageController: _pageController,
                onPageChanged: (index) => setState(
                  () {
                    tempSelect = index + 1;
                    if (widget.pageChanged != null) {}
                  },
                ),
              ),
            ),
          ),
          Positioned(
            ///布局自己换
            left: MediaQuery.of(context).size.width / 2 - 52,
            top: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Text(
                "图片预览 $tempSelect / ${widget.galleryItems.length}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
