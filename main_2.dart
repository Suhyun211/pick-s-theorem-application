import 'dart:convert';
import 'dart:io';
import 'dart:math';

final index={'구분(지역)': 0, '통신사': 1, '다운로드(Mbps)': 2, '업로드(Mbps)': 3};
//  구분(지역) -필터링 ||  통신사 -필터링
//  다운로드(Mbps) -정렬, [평균, 최소, 최대, 중앙값, 분산] ||  업로드(Mbps) -정렬, [평균, 최소, 최대, 중앙값, 분산]


void print_inventory(int page, List lines_info, List lines_list){
  /*
  page: 지정한 페이지 수
  lines_info: 각 열에 대한 정보[지역, 통신사, 다운로드, 업로드]
  lines_list: 데이터
  페이지를 출력하는 기능
   */
  print(lines_info);
  int totalpage=(lines_list.length-1)~/15+1;
  if (page!=totalpage) {
    for(var line in lines_list.sublist((page-1)*15, (page)*15)){
      print(line);
    }
  }
  else{
    for(var line in lines_list.sublist((page-1)*15)){
      print(line);
    }
  }
  print('page: ${page}/${totalpage}');
}

void page_menu(List lines_list, List lines_info){
  //페이지 선택 기능
  stdout.write('select page: ');
  String n=stdin.readLineSync()!;
  while(int.tryParse(n)==null){
    n=stdin.readLineSync()!;
  }
  int page=int.parse(n);
  print_inventory(page, lines_info, lines_list);
}

List input_target(List lines_list, {int? flg}){
  /*
  flg: 0=> 정렬, 통계 시 사용
  flg: 1=> 필터링 시 사용
  자주 쓰이는 기능, 속성을 입력받아 리턴하는 함수
  */
  String specific1='';
  String specific2='';
  while (true) {
    if(flg==0){
      //sorting, statistics 용도
      stdout.write('input target(구분(지역), 통신사, all): ');
      specific1 = stdin.readLineSync(encoding: utf8)!;
      if (specific1 != '구분(지역)' && specific1 != '통신사' && specific1 != 'all') {
        print('input is invalid!');
        continue;
      }
    }
    if(flg==1){
      //filtering 용도
      stdout.write('input target(구분(지역), 통신사): ');
      specific1 = stdin.readLineSync(encoding: utf8)!;
      if (specific1 != '구분(지역)' && specific1 != '통신사') {
        print('input is invalid!');
        continue;
      }
    }
    break;
  }
  if (specific1=='구분(지역)'){
    while (true) {
      stdout.write('input specific target(서울특별시, 대구광역시, ...): ');
      specific2 = stdin.readLineSync(encoding: utf8)!;
      if (!lines_list.map((e) => e[0]).contains(specific2)) {
        print('input is invalid!');
        continue;
      }
      break;
    }
  }
  else if (specific1=='통신사'){
    while (true) {
      stdout.write('input specific target(KT, SKT, LGU+): ');
      specific2 = stdin.readLineSync(encoding: utf8)!;
      if (!lines_list.map((e) => e[1]).contains(specific2)) {
        print('input is invalid!');
        continue;
      }
      break;
    }
  }
  return [specific1, specific2];
}
List sorted(bool reversed, List initial_list, String property, String specific1, String specific2){
  /*
  initial_list: 정렬하기 전 리스트
  property: 정렬의 기준이 될 속성(다운로드, 업로드)
  specific1: 정렬을 수행할 대상의 상위범주(all / 구분(지역)/ 통신사)
  specific2: 정렬을 수행할 대상의 하위범주(''  / 서울특별시 / KT )
  반환: 정렬된 리스트(  [구분, 통신사, 다운로드, 업로드]로 이루어진 이차원 리스트  )
  */
  List sorted_list=[];
  if(specific1=='all'){
    sorted_list = initial_list..sort( (a,b) => ((a[index[property]]*100).toInt()).compareTo((b[index[property]]*100).toInt()));
  }
  else if(specific1=='구분(지역)'){
    List unsorted=initial_list.map((a) => a[index[specific1]]==specific2 ? a : null).toList();
    unsorted=unsorted.whereType<List>().toList();
    sorted_list = unsorted..sort( (a,b) => ((a[index[property]]*100).toInt()).compareTo((b[index[property]]*100).toInt()));
  }
  else if(specific1=='통신사'){
    List unsorted=initial_list.map((a) => a[index[specific1]]==specific2 ? a : null).toList();
    unsorted=unsorted.whereType<List>().toList();
    sorted_list = unsorted..sort( (a,b) => ((a[index[property]]*100).toInt()).compareTo((b[index[property]]*100).toInt()));
  }
  if(reversed==true){
    return sorted_list.reversed.toList();
  }
  return sorted_list;
}

List sort_menu(List lines_list, List lines_info) {
  //정렬을 수행하는 메뉴
  String property;
  String specific1;
  String specific2='';
  bool reversed;
  while (true) {
    stdout.write('오름차순: 0, 내림차순: 1, top: top=> ');
    String reversed_temp = stdin.readLineSync(encoding: utf8)!;
    if(reversed_temp=='top'){
      return [-1];
    }
    if (reversed_temp != '0' && reversed_temp != '1') {
      print('input is invalid!');
      continue;
    }
    reversed= int.parse(reversed_temp)< 1 ? false : true;
    break;
  }
  while (true) {
    stdout.write('정렬 기준 입력(다운로드(Mbps),업로드(Mbps)): ');
    property = stdin.readLineSync(encoding: utf8)!;
    if (property != '다운로드(Mbps)' && property != '업로드(Mbps)') {
      print('input is invalid!');
      continue;
    }
    break;
  }
  List targetlist=input_target(lines_list, flg:0);
  specific1=targetlist[0];
  specific2=targetlist[1];
  return sorted(reversed, lines_list, property, specific1, specific2);
}

List filter_menu(List lines_list, List lines_info){
  //속성을 입력받아 그 속성만 남기는 기능
  List targetlist=input_target(lines_list, flg:1);
  String specific1=targetlist[0];
  String specific2=targetlist[1];
  List res=lines_list.map((e) => e[index[specific1]] == specific2 ? e: null).toList();
  res=res.whereType<List>().toList();
  return res;
}

void statistics_menu(List lines_list, List lines_info,int input_menu2){
  /*
  input_menu2
  1: 평균
  2: 최소
  3: 최대
  4: 중앙값
  5: 분산
  */
  List targetlist=input_target(lines_list, flg:0);
  String specific1=targetlist[0];
  String specific2=targetlist[1];
  String property;
  while (true) {
    stdout.write('대상 입력(다운로드(Mbps),업로드(Mbps)): ');
    property = stdin.readLineSync(encoding: utf8)!;
    if (property != '다운로드(Mbps)' && property != '업로드(Mbps)') {
      print('input is invalid!');
      continue;
    }
    break;
  }
  if (specific1=='all'){
    statistics(lines_list, input_menu2, property);
  }
  else{
    List slicedlist=lines_list.map((e) => e[index[specific1]]==specific2 ? e: null).toList();
    slicedlist.removeWhere((e) => e == null);
    statistics(slicedlist, input_menu2, property);
  }
}

//some implementations from scidart/numdart package, 통계를 위한 함수들
double median(List a) {
  var middle = a.length ~/ 2;
  if (a.length % 2 == 1) {
    return a[middle];
  } else {
    return (a[middle - 1] + a[middle]) / 2.0;
  }
}
double arraySum(List a) {
  var sum = 0.0;
  for (var i = 0; i < a.length; i++) {
    sum += a[i];
  }
  return sum;
}
double mean(List a) {
  return arraySum(a) / a.length;
}
double variance(List a) {
  var meanA = mean(a);
  var temp = 0.0;
  for (var el in a) {
    temp += (el - meanA) * (el - meanA);
  }
  return temp / (a.length - 1);
}

void statistics(List list, int input_menu2, String property){
  //통계를 내는 기능
  List list_prop_dynamic=list.map((e) => e[index[property]!]).toList();
  List<double> list_prop = list_prop_dynamic.cast<double>();
  if(input_menu2==1){
    //평균
    print('average: ${mean(list.map((e) => e[index[property]!]).toList())}');
  }
  if(input_menu2==2){
    //최소
    print('min: ${list_prop.reduce(min)}');
  }
  if(input_menu2==3){
    //최대
    print('max: ${list_prop.reduce(max)}');
  }
  if(input_menu2==4){
    //중앙값
    print(median(list_prop));
  }
  if(input_menu2==5){
    //분산
    print(variance(list_prop));
  }
}





void main(List<String> args){
// void main(){
  // final inputFile='data.csv';
  // final lines=File(inputFile).readAsLinesSync();
  final lines=File(args[0]).readAsLinesSync();

  List lines_list=[];
  for(var line in lines){
    var arr=line.split(',');
    lines_list.add(arr);
  }

  //각 열에 대한 정보(0행)들 따로 저장(기능 구현의 편의를 위해)
  List lines_info= lines_list[0];
  lines_list.removeAt(0);

  //리스트 안의 특정 값(다운로드, 업로드)들의 type(string)을 double로 바꾸기
  // List new_lines_list=List.filled(lines_list.length, 0);
  List new_lines_list=[];
  for(var i in lines_list){
    var l=['','',0.0,0.0];
    l[0]=i[0];
    l[1]=i[1];
    l[2]=double.parse(i[2]);
    l[3]=double.parse(i[3]);
    new_lines_list.add(l);
  }
  lines_list=new_lines_list;

  //복구 시 사용할 리스트,
  final List temp= [...lines_list];

  //초기 출력
  print_inventory(1, lines_info, lines_list);
  while(true){
    String menu1='''menu1:    
    selectpage: 1
    filtering: 2
    sort: 3
    statistics: 4
    recovery: 5
    exit: exit
    input: 
    ''';
    stdout.write(menu1);
    String input_menu1=stdin.readLineSync(encoding: utf8)!;
    if(input_menu1=='exit'){
      break;
    }
    else if(input_menu1=='1'){
      //page
      page_menu(lines_list, lines_info);
      continue;
    }
    else if(input_menu1=='2'){
      //filtering
      lines_list=filter_menu(lines_list, lines_info);
      print_inventory(1, lines_info, lines_list);
      continue;
    }
    else if(input_menu1=='3'){
      //sort
      lines_list=sort_menu(lines_list, lines_info);
      //만약 top(상위메뉴이동)을 입력했을 때
      if (lines_list.contains(-1)) {
        lines_list=[...temp];
        print_inventory(1, lines_info, lines_list);
        continue;
      }
      print_inventory(1, lines_info, lines_list);
    }
    else if(input_menu1=='4'){
      //statistics
      String menu2='''menu2:
      mean(average): 1
      minimum: 2
      maximum: 3
      median: 4
      variance: 5
      top: top
      ''';
      stdout.write(menu2);
      String input_menu2=stdin.readLineSync(encoding: utf8)!;
      if(input_menu2=='top'){
        continue;
      }
      if(int.tryParse(input_menu2)==null){
        continue;
      }
      statistics_menu(lines_list, lines_info, int.parse(input_menu2));
      continue;
    }
    else if(input_menu1=='5'){
      //recovery
      lines_list=[...temp];
      print_inventory(1, lines_info, lines_list);
      continue;
    }
    else continue;
  }
}