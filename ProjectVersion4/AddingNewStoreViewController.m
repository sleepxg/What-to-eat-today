//
//  AddingNewStoreViewController.m
//  ProjectVersion4
//
//  Created by user34 on 2017/5/25.
//  Copyright © 2017年 Lingo. All rights reserved.
//

#import "AddingNewStoreViewController.h"
#import "CoreDataHelper.h"



@interface AddingNewStoreViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *storeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) NSString * addressOfCity;
@property (nonatomic) NSDictionary * city;
@property (nonatomic) NSArray * keyOfCity;
@property (weak, nonatomic) NSString * selectCity;
@property (weak, nonatomic) NSString * selectArea;
@end

@implementation AddingNewStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCityValue];
    self.navigationItem.title = NSLocalizedString(@"addingByUser", @"");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveStoreToFavorite)];
    self.view.backgroundColor = [UIColor greenColor];
}

-(void)saveStoreToFavorite{
    
    if([self.addressTextField.text isEqualToString:@""] || [self.storeNameTextField.text isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"請輸入完整資料" message:@"地址或店名不可空白" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSManagedObjectContext *contex = [CoreDataHelper sharedInstance].managedObjectContext;
    StoreInfo *storeInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:contex];
    storeInfo.name = self.storeNameTextField.text;
    storeInfo.address = [NSString stringWithFormat:@"%@%@%@",self.selectCity,self.selectArea,self.addressTextField.text];
    storeInfo.phoneNumber = self.phoneNumberTextField.text;
    storeInfo.lat = -1;
    storeInfo.lng = -1;
    storeInfo.isFavorite = true;
    [self.favoriteData addObject:storeInfo];
    [contex save:nil];
    [self.delegate back2RootViewController:self.favoriteData theType:0];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.keyOfCity.count;
    }else{
        NSArray *temp = self.city[self.selectCity];
        return temp.count;
    }
    
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *title ;
    
    if (component == 0) {
        title = self.keyOfCity[row];
    }else{
        NSArray *temp = self.city[self.selectCity];
        title = temp[row];
    }
    
    return title;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.selectCity = self.keyOfCity[row];
        [self.cityPicker reloadComponent:1];
    } else {
        NSArray * tmp = self.city[self.selectCity];
        self.selectArea = tmp[row];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initCityValue{
    NSArray * city1 = @[@"中正區",@"大同區",@"中山區",@"松山區",@"大安區",@"萬華區",@"信義區",@"士林區",@"北投區",@"內湖區",@"南港區",@"文山區"];
    NSArray * city2 = @[@"板橋區",@"新莊區",@"中和區",@"永和區",@"土城區",@"樹林區",@"三峽區",@"鶯歌區",@"三重區",@"蘆洲區",@"五股區",@"泰山區",@"林口區",@"八里區",@"淡水區",@"三芝區",@"石門區",@"金山區",@"萬里區",@"汐止區",@"瑞芳區",@"貢寮區",@"平溪區",@"雙溪區",@"新店區",@"深坑區",@"石碇區",@"坪林區",@"烏來區"];
    NSArray * city3 = @[@"桃園區",@"中壢區",@"平鎮區",@"八德區",@"楊梅區",@"蘆竹區",@"大溪區",@"龍潭區",@"龜山區",@"大園區",@"觀音區",@"新屋區",@"復興區"];
    NSArray * city4 = @[@"中區",@"東區",@"南區",@"西區",@"北區",@"北屯區",@"西屯區",@"南屯區",@"太平區",@"大里區",@"霧峰區",@"烏日區",@"豐原區",@"后里區",@"石岡區",@"東勢區",@"新社區",@"潭子區",@"大雅區",@"神岡區",@"大肚區",@"沙鹿區",@"龍井區",@"梧棲區",@"清水區",@"大甲區",@"外埔區",@"大安區",@"和平區"];
    NSArray * city5 = @[@"中西區",@"東區",@"南區",@"北區",@"安平區",@"安南區",@"永康區",@"歸仁區",@"新化區",@"左鎮區",@"玉井區",@"楠西區",@"南化區",@"仁德區",@"關廟區",@"龍崎區",@"官田區",@"麻豆區",@"佳里區",@"西港區",@"七股區",@"將軍區",@"學甲區",@"北門區",@"新營區",@"後壁區",@"白河區",@"東山區",@"六甲區",@"下營區",@"柳營區",@"鹽水區",@"善化區",@"大內區",@"山上區",@"新市區",@"安定區"];
    NSArray * city6 = @[@"楠梓區",@"左營區",@"鼓山區",@"三民區",@"鹽埕區",@"前金區",@"新興區",@"苓雅區",@"前鎮區",@"旗津區",@"小港區",@"鳳山區",@"大寮區",@"烏松區",@"林園區",@"仁武區",@"大樹區",@"大社區",@"岡山區",@"路竹區",@"橋頭區",@"梓官區",@"彌陀區",@"永安區",@"燕巢區",@"田寮區",@"阿蓮區",@"茄萣區",@"湖內區",@"旗山區",@"美濃區",@"內門區",@"杉林區",@"甲仙區",@"六龜區",@"茂林區",@"桃園區",@"那瑪夏區"];
    NSArray * city7 = @[@"仁愛區",@"中正區",@"信義區",@"中山區",@"安樂區",@"暖暖區",@"七堵區"];
    NSArray * city8 = @[@"東區",@"北區",@"香山區"];
    NSArray * city9 = @[@"東區",@"西區"];
    NSArray * city10 = @[@"竹北市",@"竹東鎮",@"新埔鎮",@"關西鎮",@"湖口鄉",@"新豐鄉",@"峨眉鄉",@"寶山鄉",@"山埔鄉",@"穹林鄉",@"橫山鄉",@"尖石鄉",@"五峰鄉"];
    NSArray * city11 = @[@"苗栗市",@"頭份市",@"竹南鎮",@"後龍鎮",@"通霄鎮",@"苑裡鎮",@"卓蘭鎮",@"造橋鄉",@"西湖鄉",@"頭屋鄉",@"公館鄉",@"銅鑼鄉",@"三義鄉",@"大湖鄉",@"獅潭鄉",@"三灣鄉",@"南庄鄉",@"泰安鄉"];
    NSArray * city12 = @[@"彰化市",@"員林市",@"和美鎮",@"鹿港鎮",@"溪湖鎮",@"二林鎮",@"田中鎮",@"北斗鎮",@"花壇鄉",@"芬園鄉",@"大村鄉",@"永靖鄉",@"伸港鄉",@"線西鄉",@"福興鄉",@"秀水鄉",@"埔心鄉",@"埔鹽鄉",@"大城鄉",@"芳苑鄉",@"竹塘鄉",@"社頭鄉",@"二水鄉",@"田尾鄉",@"埤頭鄉",@"溪州鄉"];
    NSArray * city13 = @[@"南投市",@"埔里鎮",@"草屯鎮",@"竹山鎮",@"集集鎮",@"名間鄉",@"鹿谷鄉",@"中寮鄉",@"魚池鄉",@"國姓鄉",@"水里鄉",@"信義鄉",@"仁愛鄉"];
    NSArray * city14 = @[@"斗六市",@"斗南鎮",@"林內鄉",@"古坑鄉",@"大皮鄉",@"莿桐鄉",@"虎尾鄉",@"西螺鄉",@"土庫鎮",@"褒忠鄉",@"二崙鄉",@"崙背鄉",@"麥寮鄉",@"台西鄉",@"東勢鄉",@"北港鎮",@"元長鄉",@"四湖鄉",@"口湖鄉",@"水林鄉"];
    NSArray * city15 = @[@"太保市",@"朴子市",@"布袋鎮",@"大林鎮",@"民雄鄉",@"溪口鄉",@"新港鄉",@"六腳鄉",@"東石鄉",@"義竹鄉",@"蘆草鄉",@"水上鄉",@"中埔鄉",@"竹崎鄉",@"梅山鄉",@"番路鄉",@"大埔鄉",@"阿里山鄉"];
    NSArray * city16 = @[@"屏東市",@"潮州鎮",@"東港鎮",@"恆春鎮",@"萬丹鄉",@"崁頂鄉",@"新園鄉",@"林邊鄉",@"南州鄉",@"琉球鄉",@"枋寮鄉",@"枋山鄉",@"車城鄉",@"滿州鄉",@"高樹鄉",@"九如鄉",@"鹽埔鄉",@"里港鄉",@"內埔鄉",@"竹田鄉",@"長治鄉",@"麟洛鄉",@"萬巒鄉",@"新埤鄉",@"佳冬鄉",@"霧台鄉",@"泰武鄉",@"瑪家鄉",@"來義鄉",@"春日鄉",@"獅子鄉",@"牡丹鄉",@"三地門鄉"];
    NSArray * city17 = @[@"宜蘭市",@"頭城鎮",@"礁溪鄉",@"壯圍鄉",@"員山鄉",@"羅東鎮",@"蘇澳港",@"五結鄉",@"三星鄉",@"冬山鄉",@"大同鄉",@"南澳鄉"];
    NSArray * city18 = @[@"花蓮市",@"鳳林鎮",@"玉里鎮",@"新城鄉",@"吉安鄉",@"壽豐鄉",@"光復鄉",@"豐濱鄉",@"瑞穗鄉",@"富里鄉",@"秀林鄉",@"萬榮鄉",@"卓溪鄉"];
    NSArray * city19 = @[@"台東市",@"成功鎮",@"關山鎮",@"長濱鄉",@"池上鄉",@"東河鄉",@"鹿野鄉",@"卑南鄉",@"大武鄉",@"綠島鄉",@"太麻里鄉",@"海端鄉",@"延平鄉",@"金鋒鄉",@"達仁鄉",@"蘭嶼鄉"];
    NSArray * city20 = @[@"馬公市",@"湖西鄉",@"白沙鄉",@"西嶼鄉",@"望安鄉",@"七美鄉"];
    
    self.city = @{@"台北市":city1,@"新北市":city2,@"基隆市":city7,@"桃園市":city3,@"新竹市":city8,@"新竹縣":city10,@"苗栗縣":city11,@"嘉義縣":city15,@"嘉義市":city9,@"彰化縣":city12,@"雲林縣":city14,@"南投縣":city13,@"台中市":city4,@"台南市":city5,@"高雄市":city6,@"屏東縣":city16,@"宜蘭縣":city17,@"花蓮縣":city18,@"台東縣":city19,@"澎湖縣":city20};
    self.keyOfCity = [self.city allKeys];
    self.selectCity = @"台北市";
}
@end
