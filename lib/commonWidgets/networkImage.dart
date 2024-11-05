import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';

ClipRRect buildNetworkimage(String src, var box) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.network(
      src,
      fit: box,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.4),
            color: purpleColor,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    ),
  );
}
