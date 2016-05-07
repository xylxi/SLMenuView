#SLMenuView
一个类似QQ弹出选项的空间和一个辅助View动画弹出的类

###效果图：
![effect](https://github.com/xylxi/SLMenuView/blob/master/demo.gif)



###SLMenuView的用法：

####设置item内容

```
	let titles = ["itme1","itme2","time3","itme4","item5"]
	var items = [CLItem]()
	for i in 0..<5  {
		items.append(CLItem(title: titles[i], imageName: "love", handler: { (item) in
			print(item.title);
		}))
	}
            
```

```

####创建菜单
    let  menuView  = MeunView(items: items, direction: .downright, point: CGPoint(x: UIScreen.mainScreen().bounds.width / 2,y: UIScreen.mainScreen().bounds.height / 2 - 15), config: nil)
    // 弹出
    menuView.show()

```

###SLShowView提供简单的弹出动画，也可以由使用者自定义动画：

####枚举
```
public typealias ShowAnimalClosure   = (view: UIView?) ->Void
public typealias DismissAimalClosure = (view: UIView?, time: NSTimeInterval) ->Void

public enum SLPosition {
    // 从上滑下
    case Top
    // 中间渐显
    case Center
    // 从下往上
    case Bottom
    // 自定义展示和隐藏动画效果
    case Custom(ShowAnimalClosure,DismissAimalClosure)
}

```

#####根据枚举值，选择弹出动画
```  
class TestView: UIView,ShowDelegate {
    // 协议需要的代理
    weak var delegate: DisPlay?
    // 简单使用
    func alert(position:SLPosition) {
        let sh = SLShowView(addView: self, height: 100, position: position, needVisua: true)
        sh.show()
    }
}

``` 




