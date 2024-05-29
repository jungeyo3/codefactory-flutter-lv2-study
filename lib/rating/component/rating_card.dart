import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';
// 이걸 import하면 mapIndexed를 사용할 수 있다!
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  final ImageProvider avatarImage; // AssetImage, NetworkImage
  final List<Image> images; // CircularAvatar
  final int rating;
  final String email;
  final String content;

  const RatingCard(
      {required this.avatarImage,
      required this.images,
      required this.rating,
      required this.email,
      required this.content,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          rating: rating,
          email: email,
        ),
        const SizedBox(
          height: 8.0,
        ),
        _Body(content: content),
        if (images.length > 0)
        SizedBox(
          height: 100,
          child: _Images(
            images: images,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;

  const _Header(
      {required this.avatarImage,
      required this.rating,
      required this.email,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          // 내용이 픽셀을 넘어갈 경우 다음 줄로 넘김!
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed(
            (index, e) => Padding(
                padding: EdgeInsets.only(right: index == images.length-1 ? 0 : 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: e,
                )),
          )
          .toList(),
    );
  }
}
