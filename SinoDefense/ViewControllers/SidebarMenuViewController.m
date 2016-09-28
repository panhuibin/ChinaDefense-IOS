

#import "SidebarMenuViewController.h"

@implementation SidebarMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //add first view controller
    [self addTargetViewControllerForIndex:0];
}


#pragma mark - private class methods

- (void)addShadowToViewController:(UIViewController *)viewController {
    NSArray * controllerArray = [[self navigationController] viewControllers];
    
    for (UIViewController *controller in controllerArray){
        NSLog(@"%@",controller.title);
        NSLog(@"%@", controller.view.frame.size);
    }
    
    
    [viewController.view.layer setCornerRadius:4];
    
    [viewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
    
    [viewController.view.layer setShadowOpacity:0.8];
    
    [viewController.view.layer setShadowOffset:CGSizeMake(-2, -2)];
}


#pragma mark - public class methods

- (void)addTargetViewControllerForIndex:(NSUInteger)index {

    //fetch the target view controller
    UIViewController *currentViewController = [self.menuItemViewControllers objectAtIndex:index];
    
    //add a sidebar button to the target view controller
    [self addSidebarButtonForViewController:currentViewController];
    

    if([[self.containerController childViewControllers] count] > 0) {

        [self removeTargetViewController];
        
        [self.containerController pushViewController:currentViewController animated:NO];
    }
    else {
        
        //instantiate navigation controller container with chosen view controller
        self.containerController = [[UINavigationController alloc] initWithRootViewController:currentViewController];
        
        //add a shadow to the navigation controller container
        [self addShadowToViewController:self.containerController];
        
        //add the container controller as a child view controller to this view controller
        [self addChildViewController:self.containerController];
        
        [self.view addSubview:self.containerController.view];
        
        [self.containerController didMoveToParentViewController:self];
    }
}

- (void)updateTargetViewController: (UIViewController *) viewController{
    [self addSidebarButtonForViewController:viewController];
    if([[self.containerController childViewControllers] count] > 0) {
        
        [self removeTargetViewController];
        
        [self.containerController pushViewController:viewController animated:NO];
    }
    else {
        
        //instantiate navigation controller container with chosen view controller
        self.containerController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        //add a shadow to the navigation controller container
        [self addShadowToViewController:self.containerController];
        
        //add the container controller as a child view controller to this view controller
        [self addChildViewController:self.containerController];
        
        [self.view addSubview:self.containerController.view];
        
        [self.containerController didMoveToParentViewController:self];
    }

}

- (void)removeTargetViewController {
    
    NSArray *childViewContorllersOfContainer = [self.containerController childViewControllers];
    
    UIViewController *theChildViewController = [childViewContorllersOfContainer lastObject];
    
    [theChildViewController removeFromParentViewController];
}

- (void)addSidebarButtonForViewController:(UIViewController *)viewController {
    
    //create the sidebar button
    UIButton *sidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [UIImage imageNamed:self.sideBarButtonImageName];
    
    [sidebarButton setImage:image forState:UIControlStateNormal];
    
    [sidebarButton setShowsTouchWhenHighlighted:YES];
    
    sidebarButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    
    //add left bar button
    UIBarButtonItem *sidebarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sidebarButton];
    
    [sidebarButton addTarget:self action:@selector(toggleSidebar:) forControlEvents:UIControlEventTouchUpInside];
    
    viewController.navigationItem.leftBarButtonItem = sidebarButtonItem;
}

- (void)toggleSidebar:(id)obj {
    
    //get the position
    float xPosition = self.containerController.view.frame.origin.x;
    
    //toggle the side bar
    if(xPosition > 0.0f) {
        
        //close side bar ...
        
        [UIView animateWithDuration:0.3f animations:^(void){
            
            self.containerController.view.frame = CGRectMake(0.0f, self.containerController.view.frame.origin.y, self.containerController.view.frame.size.width, self.containerController.view.frame.size.height);
        }];
    }
    else {
        
        //open sidebar ...
        
        float distanceToMove = 250.0f;
        
        [UIView animateWithDuration:0.3f animations:^(void){
            
            self.containerController.view.frame = CGRectMake(distanceToMove, self.containerController.view.frame.origin.y, self.containerController.view.frame.size.width, self.containerController.view.frame.size.height);
        }];
    }
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.menuItemNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.menuItemNames objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self addTargetViewControllerForIndex:indexPath.row];
    
    [self toggleSidebar:nil];
}

@end
