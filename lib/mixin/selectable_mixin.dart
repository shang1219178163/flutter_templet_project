//
//  SelectableMixin.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/9 11:30.
//  Copyright © 2024/4/9 shang. All rights reserved.
//


// abstract class SelectedProtocol {
//   late String title;
//
//   late String id;
//
//   bool isSelected = false;
// }

mixin SelectedProtocol{
   String getName();
   String getId();

  late String id;

  late bool isSelected = false;
}