//
//  PrefixHeader.pch
//  MPWebViewLongTap
//
//  Created by Plum on 16/4/26.
//  Copyright © 2016年 ManPao. All rights reserved.
//

 function MyAppGetHTMLElementsAtPoint(x,y) {
        var tags = ",";
        var e = document.elementFromPoint(x,y);
         while (e) {
               if (e.tagName) {
                         tags += e.tagName + ',';
                   }
                e = e.parentNode;
            }
        return tags;
 }

 function MyAppGetLinkSRCAtPoint(x,y) {
        var tags = "";
         var e = document.elementFromPoint(x,y);
         while (e) {
                if (e.src) {
                        tags += e.src;
                         break;
                   }
                e = e.parentNode;
            }
         return tags;
    }

 function MyAppGetLinkHREFAtPoint(x,y) {
        var tags = "";
        var e = document.elementFromPoint(x,y);
        while (e) {
                 if (e.href) {
                        tags += e.href;
                       break;
                     }
                 e = e.parentNode;
             }
         return tags;
 }
