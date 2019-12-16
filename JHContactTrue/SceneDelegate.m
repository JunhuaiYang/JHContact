#import "SceneDelegate.h"
#import "PhoneViewController.h"
#import "PersonViewController.h"
#import "CollectionsViewController.h"
#import "GroupViewController.h"

// 负责 UI 的生命周期
@interface SceneDelegate ()

@end

@implementation SceneDelegate

// 必须要到这里新建窗口
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

    // 新建窗口   老版本这样创建
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    // 新版本  通过传进来的scene参数即可获得屏幕参数
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    self.window.backgroundColor = [UIColor whiteColor];

    // 创建 tabview
    PhoneViewController *phoneViewController = [[PhoneViewController alloc] init];
    PersonViewController *personViewController = [[PersonViewController alloc] init];
    CollectionsViewController *collectionViewController = [[CollectionsViewController alloc] init];
    GroupViewController *groupViewController = [[GroupViewController alloc] init];

    // 设置标题 和 图片  .title 可以同时设置
    phoneViewController.title = @"电话";
    phoneViewController.tabBarItem.image = [UIImage systemImageNamed:@"phone"];
    personViewController.title = @"联系人";
    personViewController.tabBarItem.image = [UIImage systemImageNamed:@"person"];
    collectionViewController.title = @"收藏";
    collectionViewController.tabBarItem.image = [UIImage systemImageNamed:@"star"];
    groupViewController.title = @"群组";
    groupViewController.tabBarItem.image = [UIImage systemImageNamed:@"person.2"];

    // 创建导航控制器
    UINavigationController *phoneNavigationController = [[UINavigationController alloc] initWithRootViewController:phoneViewController];
    UINavigationController *personNavigationController = [[UINavigationController alloc] initWithRootViewController:personViewController];
    UINavigationController *collectionNavigationController = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
    UINavigationController *groupNavigationController = [[UINavigationController alloc] initWithRootViewController:groupViewController];

//    NSArray *arrayVC = @[phoneViewController, personViewController, collectionViewController, groupViewController];
    NSArray *arrayVC = @[phoneNavigationController, personNavigationController, collectionNavigationController, groupNavigationController];
    // 创建分栏控制器
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = arrayVC;   // 分栏视图数组
    // 设置默认选中
    tabBarController.selectedIndex = 1;

    // 将分栏控制器设为根控制器
    [self.window setRootViewController:tabBarController];
    // 显示 Windows
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
