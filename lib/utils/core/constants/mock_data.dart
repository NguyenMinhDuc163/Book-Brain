
import 'package:flutter/material.dart';

import '../../../screen/ranking/model/ranking_user.dart';
import '../helpers/asset_helper.dart';

class MockData {
  static const describe = '''Khi một lá thư được gởi đến cho cậu bé Harry Potter bình thường và bất hạnh, cậu khám phá ra một bí mật đã được che giấu suốt cả một thập kỉ. Cha mẹ cậu chính là phù thủy và cả hai đã bị lời nguyền của Chúa tể Hắc ám giết hại khi Harry mới chỉ là một đứa trẻ, và bằng cách nào đó, cậu đã giữ được mạng sống của mình. Thoát khỏi những người giám hộ Muggle không thể chịu đựng nổi để nhập học vào trường Hogwarts, một trường đào tạo phù thủy với những bóng ma và phép thuật, Harry tình cờ dấn thân vào một cuộc phiêu lưu đầy gai góc khi cậu phát hiện ra một con chó ba đầu đang canh giữ một căn phòng trên tầng ba. Rồi Harry nghe nói đến một viên đá bị mất tích sở hữu những sức mạnh lạ kì, rất quí giá, vô cùng nguy hiểm, mà cũng có thể là mang cả hai đặc điểm trên.''';
  static const List<String> mockChapters = [
    "- Choose -",
    "Harry Potter toàn tập",
    "- Tập 1: Harry Potter và Hòn đá phù thủy",
    "-- Harry Potter và Hòn đá phù thủy - Chương 01",
    "-- Harry Potter và Hòn đá phù thủy - Chương 02",
    "-- Harry Potter và Hòn đá phù thủy - Chương 03",
    "-- Harry Potter và Hòn đá phù thủy - Chương 04",
    "-- Harry Potter và Hòn đá phù thủy - Chương 05",
    "-- Harry Potter và Hòn đá phù thủy - Chương 06",
    "-- Harry Potter và Hòn đá phù thủy - Chương 07",
  ];


  static  List<RankingUser> topUsers  = [
    RankingUser(
      name: 'Nguyễn Minh Dức',
      score: '2,569 d',
      avatarBackgroundColor: Colors.lightBlue.shade200,
      flagColor: Colors.red,
      rank: 1,
    ),
    RankingUser(
      name: 'Nguyễn Lê Quốc Khánh',
      score: '1,469 d',
      avatarBackgroundColor: Colors.pink.shade100,
      flagColor: Colors.blue,
      rank: 2,
    ),
    RankingUser(
      name: 'Nguyễn Hữu Tú Minh',
      score: '1,053 ddh',
      avatarBackgroundColor: Colors.lightBlue.shade100,
      flagColor: Colors.red,
      rank: 3,
    ),
    RankingUser(
      name: 'Dương Anh Đức',
      score: '590 điểm',
      avatarBackgroundColor: Colors.purple.shade100,
      flagColor: Colors.green,
      rank: 4,
    ),
    RankingUser(
      name: 'Nguyễn Đức Minh',
      score: '448 điểm',
      avatarBackgroundColor: Colors.brown.shade100,
      flagColor: Colors.green,
      rank: 5,
    ),
    RankingUser(
      name: 'Mai Linh',
      score: '412 điểm',
      avatarBackgroundColor: Colors.yellow.shade100,
      flagColor: Colors.red,
      rank: 6,
    ),
    RankingUser(
      name: 'Trần Văn Khoa',
      score: '389 điểm',
      avatarBackgroundColor: Colors.blue.shade100,
      flagColor: Colors.blue,
      rank: 7,
    ),
    RankingUser(
      name: 'Phạm Thị Hương',
      score: '354 điểm',
      avatarBackgroundColor: Colors.green.shade100,
      flagColor: Colors.red,
      rank: 8,
    ),
  ];


  static const List<Map<String, String>> listAllBooks = [
    {'name': 'SHOE DOG', 'image': AssetHelper.harryPotterCover},
    {'name': 'No Rules Rules', 'image': AssetHelper.bookMock},
    {'name': 'To Pixar And Beyond', 'image': AssetHelper.harryPotter2},

  ];

  static const String rv1 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
  static const String rv2 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
  static const String rv3 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";



  static const List<Map<String, String>> bookAppNotifications = [
    {
      "title": "Sách mới",
      "content": "Tiểu thuyết mới 'Hành trình bên lề' của tác giả Nguyễn Văn A vừa được thêm vào thư viện",
      "time": "Hôm nay 09:50 SA"
    },
    {
      "title": "Thử thách đọc sách",
      "content": "Bạn đã hoàn thành 20% thử thách đọc sách của tháng. Cố lên!",
      "time": "Hôm qua 14:30 CH"
    },
    {
      "title": "Khuyến mãi",
      "content": "Ưu đãi đặc biệt: Giảm 50% cho 3 cuốn sách văn học kinh điển",
      "time": "Hôm kia 11:15 SA"
    },
    {
      "title": "Sách được đề xuất",
      "content": "Dựa trên sở thích của bạn, chúng tôi gợi ý cuốn 'Người tình' của Marguerite Duras",
      "time": "Thứ Sáu 16:45 CH"
    },
    {
      "title": "Đánh dấu",
      "content": "Bạn đã đánh dấu trang 150 của cuốn 'Bên nhau trọn đời'",
      "time": "Thứ Năm 10:20 SA"
    },
    {
      "title": "Thư viện",
      "content": "Bạn có 3 cuốn sách sắp đến hạn trả",
      "time": "Thứ Tư 15:10 CH"
    },
    {
      "title": "Cộng đồng",
      "content": "Nhóm đọc sách 'Những tâm hồn đọc' vừa thêm chủ đề thảo luận mới",
      "time": "Tuần trước 08:30 SA"
    },
    {
      "title": "Cập nhật ứng dụng",
      "content": "Phiên bản mới 2.5 đã sẵn sàng với tính năng đọc sách offline",
      "time": "11/04/2024 20:15"
    },
    {
      "title": "Chế độ đọc",
      "content": "Bạn đã đọc liên tục 7 ngày. Chế độ đọc của bạn thật ấn tượng!",
      "time": "10/04/2024 09:45 SA"
    },
    {
      "title": "Gợi ý sách",
      "content": "Hôm nay, hãy thử thể loại khoa học viễn tưởng với cuốn 'Dune'",
      "time": "09/04/2024 17:30 CH"
    }
  ];

  static const contentBook = ''' Ông bà Dursley, nhà số 4 đường Privet Drive, tự hào mà nói họ hoàn toàn bình thường, cám ơn bà con quan tâm. Bà con đừng trông mong gì họ tin vào những chuyện kỳ lạ hay bí ẩn, đơn giản là vì họ chẳng hơi đâu bận tâm đến mấy trò vớ vẩn đó.
Ông Dursley là giám đốc một công ty gọi là Grunnings, chuyên sản suất máy khoan. Ông là một người cao lớn lực lưỡng, cổ gần như không có, nhưng lại có một bộ ria mép vĩ đại. Bà Dursley thì ốm nhom, tóc vàng, với một cái cổ dài gấp đôi bình thường, rất tiện cho bà nhóng qua hàng rào để dòm ngó nhà hàng xóm. Hai ông bà Dursley có một cậu quý tử tên là Dudley, mà theo ý họ thì không thể có đứa bé nào trên đời này ngoan hơn được nữa.
Gia đình Dursley có mọi thứ mà họ muốn, nhưng họ cũng có một bí mật, và nỗi sợ hãi lớn nhất của họ là cái bí mật đó bị ai đó bật mí. Họ sợ mình sẽ khó mà chịu đựng nổi nếu câu chuyện về gia đình Potter bị người ta khám phá. Bà Potter là em gái của bà Dursley, nhưng nhiều năm rồi họ chẳng hề gặp gỡ nhau. Bà Dursley lại còn giả đò như mình không có chị em nào hết, bởi vì cô em cùng ông chồng vô tích sự của cô ta chẳng thể nào có được phong cách của gia đình Dursley.
Ông bà Dursley vẫn rùng mình ớn lạnh mỗi khi nghĩ đến chuyện hàng xóm sẽ nói gì nếu thấy gia đình Potter xuất hiện trước cửa nhà mình. Họ biết gia đình Potter có một đứa con trai nhỏ, nhưng họ cũng chưa từng nhìn thấy nó. Đứa bé đó cũng là một lý do khiến họ tránh xa gia đình Potter: Họ không muốn cậu quý tử Dudley chung chạ với một thằng con nít nhà Potter.
Vào một buổi sáng thứ ba xám xịt âm u, ông bà Dursley thức dậy, chẳng hề cảm thấy chút gì rằng bầu trời đầy mây kia đang báo hiệu những điều lạ lùng bí ẩn sắp xảy ra trên cả nước Anh. Ông Dursley ậm ừ khi chọn cái cà-vạt chán nhất thế giới đeo vào cổ đi làm. Bà Dursley thì lách chách nói trong lúc vật lộn với cậu quý tử Dudley đang gào khóc vùng vẫy, không chịu ngồi ăn sáng tử tế. Không một ai để ý đến một con cú to và đen thui bay xẹt qua cửa sổ.
Tám giờ rưỡi, ông Dursley sách cặp, hửi cồ bà Dursley một cái và cố hôn cậu quý tử trước khi đi làm. Nhưng cậu Dudley đang chơi trò đánh trống thổi kèn, phun phèo phèo thức ăn và vun vãi mọi thứ tứ tung, kể cả cái hôn của cha. Ông Dursley vừa cười khoái chí: “Thằng chó con”, vừa đi ra khỏi nhà. Ông lên xe, lái ra khỏi ngôi nhà số 4 của mình.
Chính ở ngay góc đường, ông nhận thấy dấu hiệu đầu tiên của chuyện lạ: Một con mèo xem bản đồ. Thoạt tiên, ông Dursley không nhận ra đó là chuyện kỳ quái. Thế rồi ông giật mình quay lại nhìn lần nữa. Có một con mèo hoang đứng ở góc đường Privet Drive, nhưng bây giờ lại chẳng có tấm bản đồ nào cả! Chẳng lẽ chuyện đó là do ông tưởng tượng ra ư? Hay ánh sáng đã làm ông lóa mắt? Ông Dursley chớp chớp mắt rồi chăm chú nhìn con mèo. Nó cũng nhìn lại ông.
Ông lái xe vòng qua góc đường, đi tiếp, và tiếp tục nhìn con mèo qua kính chiếu hậu. Nó lúc ấy đang đọc bảng tên đường Privet Drive- À không, ngó bảng tên đường chứ, mèo đâu có thể đọc bảng tên đường hay xem bản đồ! Ông Dursley lắc lắc đầu, đuổi con mèo ra khỏi óc. Khi lái xe vào thành phố, ông không muốn nghĩ đến cái gì khác hơn là những đơn đắt hàng máy khoan mà ông mong có được nhiều thật nhiều trong ngày hôm đó.
Nhưng sắp vào tới thành phố, chợt có một việc khiến ông không còn tâm trí nghĩ đến những chiếc máy khoan nữa: lúc ngồi đợi trong xe, giữa dòng xe cộ kẹt cứng, ông không thể không nhận thấy hình như xung quanh có rất nhiều người ăn mặc lạ lùng đang lảng vảng. Tất cả bọn họ đều mặc áo trùm kín. Ông Dursley vốn đã không chịu nổi bọn người ăn mặc dị hợm- những thứ lôi thôi mà đám trẻ vẫn mặc!- nên ông cho là lần này chắc lại là một thời trang ngu ngốc nào đó xuất hiện.
Ông sốt ruột nhịp ngón tay trên tay lái xe hơi và ánh mắt ông đụng nhằm một cặp quái đang chụm đầu đứng gần đó. Họ đang thì thầm với nhau coi bộ rất kích động. Ong Dursley giận sôi lên khi nhận thấy cặp này cũng chẳng còn trẻ gì: Coi, gã đàn ông trông còn già hơn cả ông, vậy mà lại khoác áo trùm màu xanh ngọc bích! Chẳng ra thể thống gì cả! Đầu óc gì thế chứ! Nhưng ông Dursley chợt giật mình- hình như những người này đang tụ tập vì một chuyện gì đó… Ừ, hình như vậy!…
Dòng xe cộ thông, và chỉ vài phút sau ông Dursley đã lái xe vào bãi đậu của hãng Grunnings, đầu óc ông giờ đã quay trở lại với mấy cái máy khoan.
Trong văn phòng ở lầu chín, ông Dursley thường vẫn hay ngồi quay lưng lại cửa sổ. Giả sử không ngồi kiểu đó, thì rất có thể sáng hôm ấy ông sẽ khó tập trung được vô mấy cái máy khoan. Bởi ngồi như vậy, nên ông đã không thấy, bên ngoài cửa sổ, một đàn cú bay lượn xao xác giữa ban ngày. Mọi người dưới phố đều trông thấy, nhưng ông Dursley thì không. Người ta chỉ trỏ kinh ngạc, thậm chí há hốc mồm khi ngước nhìn đàn cú bay vụt qua ngay trên đầu, nhiều người trong số đám đông ấy thậm chí chưa từng thấy một con cú vào nửa đêm, đừng nói chi giữa ban ngày như thế này.
Ai cũng thấy chỉ riêng ông Dursley là không thấy. Ông đã trãi qua một buổi sáng hoàn toàn bình thường, không có cú. Sáng đó, ông quát tháo năm người khác nhau. Ông gọi nhiều cú điện thoại quan trọng và la hét thêm một hồi. Tâm trạng ông sảng khoái cho đến bữa ăn trưa, và tự nhủ mình phải duỗi chân cẳng một chút, băng qua đường, mau cho mình một cái bánh ở tiệm bánh mì.
Ông hầu như đã quên bén những người khoác áo trùm kín cho tới khi đi ngang qua một đám người đứng gần tiệm bánh. Cả bọn đều mặc áo trùm. Ông nhìn họ giận dữ. Ông không biết tại sao, nhưng họ làm ông khó chịu quá. Bọn này thì thào với nhau có vẻ rất kích động, mà ông thì không nghe được tí teọ nào. Chỉ đến lúc trên đường về từ tiệm bánh mì, đi ngang qua đám người khoác áo trùm, ông Dursley mới nghe lõm bỏm được những gì họ nói:
- Gia đình Potter, đúng đấy. Tôi nghe đúng như thế…
- … Ừ, con trai họ, Harry…
Ông Dursley đứng sững lại, chết lặng. Ông ngợp trong nỗi sợ hãi. Ông ngoái nhìn đám người đang thì thào như muốn nói gì với họ, nhưng rồi lại thôi.
Ông băng nhanh qua đường, vội vã về văn phòng, nạt viên thư ký là đừng có quấy rầy ông, rồi cầm điện thoại lên, sắp quay xong số gọi về nhà thì lại đổi ý. Ông đặt ống nghe xuống, tay rứt rứt hàng ria, suy nghĩ… Không, ông hơi hồ đồ. Potter đâu phải là một cái họ hiếm hoi gì. Ông dám chắc là có hàng đống người mang họ Potter và đặt tên con mình là Harry. Nghĩ đi nghĩ lại thật kỹ, ông thấy cũng không chắc thằng cháu của ông tên là Harry. Ông chưa từng gặp nó. Biết đâu nó tên là Harvey hay Harold. Chẳng việc gì ông phải làm phiền đến bà Dursley; bả luôn luôn nổi giận và buồn bực khi nghe nhắc đến cô em gái của mình. Ông cũng chẳng trách bà, ông cũng sẽ thế thôi nếu ông có một cô em gái như thế… Nhưng mà em của bà hay em của ông thì đằng nào cũng vậy. Nhưng… cái bọn khoác áo trùm!…
Buổi trưa đó, ông bỗng thấy khó mà tập trung vô mấy cái máy khoan, và khi rời sở làm lúc năm giờ chiều thì ông trở nên lo âu và căng thẳng đến nỗi đâm sầm vào một người ở ngoài cửa.
- Xin lỗi!
Ông càu nhàu với người đàn ông nhỏ thó bị ông đâm vào làm cho suýt ngã bổ ra sau. Nhưng chỉ vài giây sau, ông Dursley chợt nhận ra là gã đàn ông đó cũng khoác áo trùm màu tím. Gã không tỏ vẻ cáu giận về chuyện gã suýt bị lăn quay ra đất. Ngược lại, mặt gã giãn ra một nụ cười toe toét, và gã nói với một giọng mơ hồ khiến mọi người đi ngang phải ngoái nhìn.
- Đừng lo, thưa ngài, hôm nay không có gì có thể làm tôi nổi cáu được đâu. Vui lên đi. Bởi vì kẻ – mà – ai – cũng – biết – là – ai – đấy cuối cùng đã biến rồi! Ngay cả dân Muggle như ngài cũng nên ăn mừng cái ngày vui vẻ, rất vui vẻ này đi.
Và gã đàn ông ôm ngang người ông Dursley một cách thân tình rồi bỏ đi.
Ông Dursley đứng như trời trồng tại chỗ. Ông bị một người hoàn toàn xa lạ ôm thân tình một cái! Ông lại bị gọi là dân Muggle, không biết là cái quỷ gì? Ông ngạc nhiên quá. Vội vã ra xe, ông lái về nhà, hy vọng là những gì xảy ra chẳng qua là do ông tưởng tượng mà thôi. Nhưng mà trước nay, cókhi nào ông công nhận là có trí tưởng tượng ở trên đời đâu!
Khi cho xe vào ngõ nhà số 4, cái trước tiên mà ông nhìn thấy – và cũng chẳng làm cho ông dễ thở hơn chút nào – là con mèo hoang to tướng mà ông đã thấy hồi sáng. Con mèo đang ngồi chong ngóc trên bờ tường khu vườn nhà ông. Ông chắc là đúng con mèo hồi sáng, bởi quanh mắt nó cũng có viền hình vuôn. Ông Dursley xuỵt lớn:
- Xù.
Con mèo chẳng thèm nhúc nhíc. Nó còn nhìn lại ông một cách lạnh lùng. Ông Dursley thắc mắc. Không biết có phải kiểu cư xử thông thường của mèo là vậy? Cố gắng lấy lại vẻ tự chủ, ông đĩnh đạc bước vào nhà. Ông vẫn còn quyết tâm là sẽ không nói gì với vợ về chuyện Potter.
Bà Dursley cũng trãi qua một ngày bình thường tốt đẹp. Trong bữa ăn tối, bà kể cho chồng nghe chuyện rắc rối của nhà hàng xóm và con gái của họ, cùng chuyện hôm nay Dudley học nói được thêm hai từ mới (“hổng thèm”). Ông Dursley cố gắng cư xử như bình thường. Khi bé Dudley được đặt lên giường ngủ thì ông vào phòng khách để xem bản tin buổi tối.
- Và cuối cùng, thưa quý vị khán giả, những người quan sát cầm điểu khắp nơi báo cáo là chim cú trên cả nước đã hành động hết sức bất thường suốt ngày hôm nay. Mặc dù cú thường đi săn vào ban đêm và ít khi xuất hiện vào ban ngày, nhưng cả ngày nay, từ sáng sớm, đã có hàng trăm con cú bay tứ tán khắp mọi hướng. Các chuyên viên không thể giải thích nổi tại sao cú lại thay đổi thói quen thức ngủ như vậy.
Phát ngôn viên nói tới đây tự thưởng cho mình một nụ cười rồi tiếp:
- Cực kỳ bí hiểm. Và bây giờ là phần dự báo thời tiết của Jim McGuffin. Liệu đêm nay còn trận mưa cú nào nữa không Jim?
Người dự báo thời tiết đáp:
- À, tôi không rành vụ đó lắm,nhưng ngày hôm nay không chỉ có cú hành động quái chiêu, mà thời tiết cũng tỏ ra bất bình thường. Nhiều quan sát viên ở các vùng khác nhau đã gọi điện thoại phàn nàn với tôi là thay vì một trận mưa như tôi đã dự báo ngày hôm qua, thì họ lại nhận được một trận sao băng. Không chừng người ta ăn mừng lễ đốt pháo bông quá sớm, nhưng thưa bà con, tuần sau mới tới ngày đốt pháo bông mà! Dù vậy tôi xin cam đoan là thời tiết tối nay sẽ rất ẩm ướt.
Ông Dursley ngồi như đóng băng trên ghế bành. Sao băng trên khắp bầu trời Anh – cát – lợi à? Cú bay lượn vào ban ngày ư? Những con người khoác áo trùm bí ẩn khắp nơi nữa chứ. Và… và những câu chuyện thì thào về gia đình Potter…
Bà Dursley bưng hai tách trà vào phòng. Không ổn rồi. Ông phải nói gì với bà thôi. Ông tằng hắng lấy giọng:
- Ờ… em à… lâu nay em không nghe nói gì về em gái của em phải không?
- Không.
Đúng như ông “mong đợi”, bà Dursley giật mình và đổ quạu. Chẳng phải là lâu nay cả hai đã ngầm coi như bà chẳng hề có chị em gì hết sao? Giọng bà sắc lẻm:
- Mà sao?
Ông Dursley lầu bầu:
- À, chỉ là ba mớ tin tức… cười. Nào là cú… sao băng… lại có cả đống bọn khoác áo trùm nhôn nhạo dưới phố hôm nay…
- Thì sao? – Bà Dursley ngắt ngang.
Ông Dursley vội phân bua:
- Ờ… anh chỉ nghĩ… có thể… có chuyện gì đó dính dáng tới dì nó… em biết đó… dì nó…
Bà Dursley nhấp môi son vào tách trà. Ông Dursley băn khoăn không biết liệu mình có dám nói với vợ là đã nghe thiên hạ bàn tán về cái tên “Potter” không.Cuối cùng ông không dám. Thay vào đó, ông cố làm ra vẻ hết sức bình thường:
- Thằng con trai của họ… chắc là nó bằng tuổi bé Dudley nhà mình, phải không em?
Bà Dursley nhấm nhẳn:
- Có lẽ
- Nó tên gì? Howard phải không?
- Harry. Một cái tên tầm thường xấu xí.
- Ờ, xấu thật. Anh hoàn toàn đồng ý với em.
Ông không nói thêm lời nào nữa về đề tài này khi cả hai lên lầu vào phòng ngủ. Trong khi bà Dursley vào buồn tắm, ông Dursley đứng bên cửa sổ nhìn ra vườn. Con mèo vẫn còn đó. Nó đang chăm chu ngóng ra đường Privet Drive như thể đang chờ đợi cái gì vậy.
Hay là ông chỉ tưởng tượn ra mọi thứ? Tất cả những chuyện vớ vẩn này thì có liên quan gì tới gia đình Potter nào? Nếu có… nếu mà có dính dáng với cặp phù… Oâi, nghĩ tới đó ông đã cảm thấy không chịu nổi.
Ông bà Dursley lên giường ngủ. Bà Dursley ngủ ngay tức thì, còn ông Dursley thì cứ nằm trăn trở mãi. Cuối cùng một ý nghĩ dễ chịu đã giúp ông ngủ thiếp đi, ấy là nếu mà gia đình Potter có dính dáng đến tất cả những chuyện nhảm nhí ấy thì họ cũng không có lý do gì để dây dưa đến gia đình ông. Gia đình Potter biết rất rõ bà Dursley nghĩ như thế nào về họ và bọn người như họ. Ông Dursley thấy không có lý do gì để mình và vợ mình có thể bị khổ sở về những gì đang diễn ra – Ông ngáp và trở mình – Chuyện đó không thể nào ảnh hưởng đến họ.
Nhưng ông đã lầm.
Ông Dursley cuối cùng cũng có thể tóm được giấc ngủ, dù một cách khó khăn. Nhưng con mèo ngồi trên bờ tường ngoài thì không tỏ vẻ gì buồn ngủ cả. Nó cứ ngồi bất động, mắt đăm không chớp về góc đường Privet Drive. Nó không động đậy ngay cả khi có tiếng cửa xe đóng sầm bên kia đường. Không nhúc nhích ngay cả khi có hai con cú vụt qua phía trên đầu. Và chính xác là đến gần nữa đêm con mèo ấy mới nhúc nhích.
Ấy là lúc một ông già xuất hiện ở góc đường mà con mèo đang ngóng về. Cụ xuất hiện thình lình và lặng lẽ như thể từ mặt đất chui lên. Đuôi con mèo nhẹ ve vẩy và mắt nó nhíu lại.
Xưa nay trên đường Privet Drive chưa từng có một người nào trông kỳ quái như cụ già ấy lại qua. Cụ ốm, cao, rất già, căn cứ vào mái tóc và chòm râu bạc phơ dài đến nỗi cụ phải giắt chúng vô thắt lưng. Cụ mặc áo thụng dài, khoát áo trùm màu tím cũng dài quét đất, mặc dù cụ đã mang đôi giày bốt cao gót lêu nghêu. Đôi mắt xanh lơ của cụ sáng rỡ và lấp lánh phía sau cặp kính có hình dạng nữa vành trăng. Mũi cụ thì vừa dài vừa khoằm như thể cụ đã từng bị gãy mũi ít nhất hai lần. Tên cua cụ là Albus Dumbledore.
Albus Dumbledore dường như không nhận thấy là mình đã đến con đường mà từ tên họ cho đến đôi bốt của cụ không hề được hoan nghênh chào đón. Cụ đang bận lục lọi trong chiếc áo trùm của cụ, tìm kiếm cái gì đó. Rồi đột nhiên, có vẻ như cụ nhận ra là mình đang bị quan sát, bởi vì cụ thình lình ngước nhìn lên con mèo vẫn đang ngó cụ từ bờ tường nhà Dursley. Aùnh mắt của con èmo có vẻ làm cụ thích thú. Cụ chắc lưỡi lẩm bẩm:
- Lẽ ra mình phải biết rồi chứ!
Cụ đã tìm được cái mà cụ lục lọi nãy giờ trong chiếc áo trùm. Nó giống như cái bật lửa bằng bạc. Cụ giơ nó lên cao và bấm. Ngọn đèn đường gần nhất tắt phụt. Cụ bấm lần nữa, ngọn đèn đường kế tiếp tắt ngấm. Cụ bấm mười hai lần như thế, cho đến khi ánh sáng còn lại trên cả con đường chỉ còn là hai đốm sáng long lanh ở phái xa – đó là hai con mắt mèo đang nhìn cụ. Nếu bây giờ mà có ai nhìn qua cửa sổ ra đường, thì dù có con mắt tọc mạch như bà Dursley cũng chịu, không thể thấy được cái gì đang xảy ra. Cụ Albus Dumbledore cất cái tắt – lửa vào áo trùm và đi về phía ngôi nhà số 4 đường Privet Drive. Cụ ngồi xuống trên bờ tường, cạnh con mèo. Cụ không nhìn nó, nhưng được một lúc, cụ nói: “Thật là hay khi gặp bà ở đây đấy, giáo sư McGonagall!”
Cụ quay sang để mỉm cười với con mèo, nhưng chẳng còn mèo nào cả. Thay vì vậy cụ đang mỉm cười với một bà lão trông đứng đắn, đeo kính gọng vuông y như cái dấu vuôn quanh mắt con mèo. Bà cũng khoác áo trùm, màu ngọc bích. Tóc bà bới thành một búi chặt. Bà có vẽ phật ý rõ rệt:
- Làm sao ông biết con mèo đấy là tôi?
- Thưa bà giáo sư yêu quý của tôi, hồi nào tới giờ tôi chưa từng thấy một con mèo nào ngồi cứng đờ như thế.
Giáo sư McGonagall nói:
- Ông mà ngồi cả ngày trên bờ tường thì ông cũng cứng đờ thế thôi.
- Cả ngày?trong khi lẽ ra bà đang phải mở tiệc ăn mừng chứ? Trên đường đến đây, tôi đã gặp ít nhất cả chục đám tiệc tùng linh đình rồi.
Giáo sư McGonagall hít hơi một cách giận giữ và nói một cách không kiên nhẫn:
- Vâng, mọi người ăn mừng, được thôi. Đáng lẽ ông phải thấy là họ nên cẩn thận một chút chứ – ngay ca dân Muggles cũng nhận thấy có chuyện gì đó đang xảy ra. Họ thông báo trong chương trình thời sự đấy.
Bà hất đầu về phía cửa sổ phòng khách tối om của gia đình Dursley.
- Tôi nghe hết.Những đàn cú… sao băng… Chà, họ không hoàn toàn ngu ngốc cả đâu. Họ đã nhận ra có điều gì đó. Sao băng… Tôi cá đó là trò của Diggle, hắn thật chẳng có đầu óc gì cả.
Albus Dumbledore nhẹ nhàng bảo:
- Bà không thể trách như vậy được. Đã mười một năm nay chúng ta chẳng có dịp nào để vui mừng mà!
Giáo sư McGonagall vẫn cáu kỉnh:
- Tôi biết. Nhưng đó không phải là lý do để phát điên lên. Đám đông cứ nhởn nhơ tụ tập bừa bãi trên đường phố giữa ban ngày, thậm chí không thèm mặc quần áo của dân Muggle để ngụy trang, lại còn bàn tán ầm ĩ.
Bà liếc sang cụ Albus Dumbledore ngồi bên, như thể hy vọng cụ sẽ nói với bà điều gì, nhưng cụ không nói gì cả, nên bà nói tiếp:
- Giá mà khi kẻ – mà – ai – cũng – biết – là – ai – đấy biến đi hẳn, người Muggle mới phát hiện ra chúng ta thì hay biết mấy. Nhưng tôi không chắc là hắn đã chết thật chưa hả ông Dumbledore?
- Chắc chắn như vậy rồi. Thật là phước đức cho chúng ta! Bà có dùng giọt chanh không?
- Giọt gì?
- Giọt chanh. Đó là một loại keo của dân Muggle mà tôi rất khoái.
- Không cám ơn.
Giáo sư McGonagall lạnh lùng từ chối, bà không nghĩ là nhấm nháp kẹo lúc này lại thích hợp.
- Như tôi nói đấy, ngay cả nếu như kẻ – mà – ai – cũng – biết – là – ai – đấy đã biến…
- Ôi, giáo sư yêu quý của tôi, một người có đầu óc như bà có thể gọi hắn bằng tên cúng cơm chứ? Mớ bá láp kẻ – mà – ai – cũng – biết – là – ai – đấy thiệt là nhảm nhí. Mười một năm nay tôi đã chẳng bảo mọi người cứ gọi hắn đúng theo tên của hắn: Voldemort sao?
Giáo sư McGonagall e dè nhnìn quanh. Nhưng cụ Dumbledore có vẻ như chẳng để ý gì, cụ đang chăm chú gỡ hai viên kẹo dính nhau và cụ nói tiếp:
- Nếu mà chúng ta cứ gọi bằng: kẻ – mà – ai – cũng – biết – là – ai – đấy thì mọi sự cứ rối beng lên. Tôi thấy chẳng có gì để sợ khi gọi bằng tên cúng cơm của Voldemort.
Giáo sư McGonagall nói, giọng nữa lo lắng nữa ngưỡng mộ:
- Tôi biết ông không sợ. Nhưng ông thì khác. Mọi người đều biết ke û- ma ø- ai – cũng – biết – là… thôi được, goi là Voldemort đi, hắn chỉ sợ có mỗi mình ông mà thôi.
Cụ Albus Dumbledore bình thản nói:
- Bà tâng bốc tôi quá. Voldemort có những quyền lực tôi không bao giờ có.
- Ấy là chỉ bởi vì ông… ừ, ông quá cao thượng nên không xài tới những quyền lực đó.
- Cũng may là trời tối nhé. Kể cũng lâu rồi tôi chưa đỏ mặt, từ cái lần bà Pomfrey nói bả khoái cái mũ trùm tai của tôi.
Giáo sư McGonagall liếc cụ Dumbledore một cái sắc lẻm.
- Mấy con cú lượn vòng vòng chỉ chờ tung tin vịt đấy. Ông biết mọi người đang nói gì không? Về vì sao hắn phải biến đi ấy? Về cái điều đã chặn đứng được hắn ấy?
Có vẻ như giáo sư McGonagall đã gạt tới điểm then chốt mà bà muốn tranh luận. Đó là lý do khiến bà đã phải ngồi chờ suốt cả ngày trên bờ tường cứng và lanh lẽo này. Rõ ràng là chuyện mà mọi người đang bàn tán, cho dù làchuyện gì đi nữa, bà cũng không vôi tin cho đến khi Dumbledore nói với bà là chuyện đó có thật. Tuy nhiên cụ Dumbledore vẫn đang bận lựa một viên kẹo khác chứ không trả lời.
- Chuyện mà họ đang bàn tán ấy,” bà McGonagall nhấn mạnh, “là tối hôm qua Voldemort đã đến Hố Thần. Hắn đi tìm gia đình Potter. Nghe đồn rằng vợ chồng Potter đã… đã…, họ đồn thôi, đã… chết rồi!
Cụ Dumbledore cúi đầu. Giáo sư McGonagall há hốc miệng, ngẹn ngào:
- Vợ chồng Potter… Tôi không thể tin được… Tôi không muốn tin… Ôi, ông Dumbledore…
Cụ Dumbledore duỗi tay vỗ nhê lên vai bà giáo sư, cụ chậm rãi nói:
- Tôi biết… Tôi biết…
Giọng giáo sư McGonagall run run tiếp tục:
- Mà chuyện chưa hết. Họ còn nói hắn tìm cách giết cả đứa con trai của Potter, bé Harry ấy. Nhưng… hắn không giết được> Hắn không thể giết nổi đứa bé. Không ai biết tại sao, thế nào…, nhưng họ nói… khi không thể giết được Harry Potter, quyền lực của Voldemort bị tiêu tan. Chính vì vậy mà hắn cũng phải biến đi.
Cụ Dumbledore buồn bã gật đầu. Giáo sư McGonagall ấp úng:
- Chuyện đó… đó… là… là… thật sao? Hắn đã làm bao nhiêu chuyện tai quái, giết chết bao nhiêu người.. mà…, mà rốt cuộc hắn không thể giết nỗi một thằng bé? Thật là không tin được… cái gì đã chặn nổi bàn tay hắn như vậy… Nhưng bằng cách nào mà Harry Potter sống sót?
Cụ Dumbledore nói:
- Chúng ta chỉ có thể đoán mò mà thôi. Chuyện ấy chẳng bao giờ biết được chính xác.
Giáo sư McGonagall rút ra một cái khăn tay chùi nước mắt dưới cặp mắt kính. Cụ Dumbledore thở dài một tiếng rõ to khi rút chiếc đồng hồ vàng trong túi ra xem xét. Cái đồng hồ ấy cũ lắm. Nó có mười hai kim nhưng không có số. Thay vào những con số là các hành tinh nho nhỏ di chuyển quanh mép đồng hồ. Nhưng chắc là cụ Dumbledore coi giờ được bằng cái đồng hồ đó, nên khi nhét nó lại vào trong túi, cụ nói:
- Hagrid đến trễ. Chắc chính lão nói cho bà biết là tôi đến đây, đúng không?
- Đúng.
Giáo sư McGonagall xác nhận và nói tiếp:
- Chắc ông cũng không thèm nói cho tôi biết tại sao ông đến đây chứ?
- Tôi đến đây để giao Harry Potter cho dì dượng nó. Bây giờ nó chỉ còn có họ là bà con.
Giáo sư McGonagall nhảy dựng lên, chỉ tay vào ngôi nhà số 4:
- Ông nói gì? Chắc là ông không có ý nói đến mấy người sống trong đó chứ? Dumbledore, ông không thể làm vậy. Tôi đã quan sát họ suốt cả ngày. Ông không thể tìm ra được người nào khá hơn họ hay sao? Mà họ cũng đã có một đứa con trai. Tôi đã nhìn thấy thằng nhóc ấy, nó đá mẹ nó suốt quãng đường đến tiệm bánh kẹo, khóc la vòi vĩnh cho được mấy viên kẹo. Harry Potter mà phải đến sống ở đây sao?
Cụ Dumbledore khẳng định:
- Đây là nơi tốt nhất cho đứa bé. Khi nó lớn lên dì dượng của nó có thể giải thích cho nó hiểu. Tôi đã viết cho họ một lá thư.
- Một lá thư?
Giáo sư McGonagall lập lại yếu ớt, thả người ngồi xuống bờ tường, băn khoăn nói tiếp:
- Ông Dumbledore, ông thật sự tin là ông có thể giải thích mọi chuyện trong một lá thư à? Mấy người đó sẽ không bao giờ hiểu đứa bé! Nó sẽ nổi tiếng - như một huyền thoại. Tôi sẽ không ngạc nhiên nếu sau này người ta gọi ngày hôm nay là ngày Harry Potter: sẽ có sách viết về Harry. Mọi đứa trẻ trong thế giới chúng ta rồi sẽ biết đến tên nó!
- Đúng vậy.
Cụ Dumbledore nhướn mắt dòm qua đôi kính nữa vành trăng của cụ một cách nghiêm túc nói rằng:
- Nhiêu đó cũng đủ hại đầu óc bất cứ đứa trẻ nào. Nổi tiếng trước cả khi biết đi biết nói! Nổi tiếng về những điều mà nó cũng không thể nhớ được! Bà không thấy là tốt cho nó hơn biết bao nếu nó lớn lên ngoài vòng bao phủ của tiếng tăm, lớn lên một cách bình thường cho đến khi nó đủ lớn để làm chủ được điều đó sao?
Giáo sư McGonagall lại há hốc miệng thay đổi ý kiến, nuốt vô, ngậm miệng lại rồi nói:
- Vâng, vâng, dĩ nhiên là ông nói đúng. Nhưng mà ông Dumbledore ơi, làm sao đứa bé đến đây được?
Bà giáo sư nhìn chòng chọc vào tấm áo trùm của cụ Dumbledore như thể là bà nghĩ cụ đang giấu đứa bé trong đó. Cụ Dumbledore nói:
- Hagrid đang mang nó đến.
- Ông cho là giao lão Hagrid một viêc quan trọng như thế này là khôn ngoan sao?
- Tôi có thể giao cả đời tôi cho Hagrid.
Bà McGonagall vẫn không bằng lòng:
- Tôi không nói là lão Hagrid không biết phải quấy, nhưng mà ông cũng biết đấy, lão là chúa ẩu… Uûa? Cái gì vậy?
Một tiếng động trầm trầm nổi lên quanh họ, nghe rầm rầm, càng lúc càng lớn. Cả hai nhìn ra đường xem có ánh đèn xe không, thế rồi những tiếng động nghe như sấm dội khiến cả hai người ngước nhìn lên trời: một chiếc xe gắn máy khổng lồ chạy trên không trung rồi hạ xuống, lăn bánh trên mặt đường nhựa trước mặt họ.
Nếu cái xe gắn máy bự quá khổ, thì cũng không thấm gì so với người ngồi trên xe. Lão hầu như cao gấp đôi người bình thường và bự có đến gấp năm, nếu tính chiều ngang. Trông lão ta to lớn đến nỗi khó tin, và lại hoang dã. Những nùi tóc râu đen thui hầu như che kín gương mặt lão, tay lão trông như cần cẩu, còn chân thì ú na ú núc như mính con cá heo con. Trên đôi tay vạm vỡ ấy là một nùi chăn tả. Cụ Dumbledore tỏ ra yên tâm, bảo:
- Hagrid, cuối cùng anh đã đến. Anh kiếm đâu ra cái xe đó?
Lão khổng lồ cẩn thận trèo xuống xe đáp:
- Kính thưa ngài giáo sư Dumbledore, tôi mượn của Sirius Đen. Thưa ngài, tôi đã mang được cậu bé đến đây.
- Có lôi thôi rắc rối gì không?
- Thưa ngài không ạ. Ngôi nhà hầu như tan hoang, nhưng tôi đã kịp đem nó ra trước khi dân Muggle bắt đầu lăng xăng chung quanh. Đang bay tới đây thì nó lăn ra ngủ.
Cụ Dumbledore và giáo sư McGonagall cúi xuống đống chăn tã. Bên trong mớ chăn ấy là đứa bé đang ngủ say. Trên vầng trán đứa bé có một vết thương nhỏ hình tia chớp. Giáo sư McGonagall thì thầm:
- Có phải đó là…
- Phải, nó sẽ mang vết thẹo đó suốt đời.
- Ông không thể xoá nó đi sao ông Dumbledore?
- Nếu mà tôi làm được thì tôi cũng chẳng đời nào làm. Thẹo cũng có lúc xài đến. Tôi đây cũng có một cái thẹo ở trên đầu gối, nó có giá trị như cái bảng đồ đường xe điện ngầm ở Luân – Đôn ấy. Thôi, Hagrid, đặt nó ở đây, chúng ta nên làm xong chuyện này cho rồi.
Cụ Dumbledore bồng Harry đi về phía nhà Dursley. Lão Hagrid ấp úng:
- Tôi… tôi có thể hôn tạm biệt đứa bé được không ạ?
Lão cuối cái đầu lông lá bờm xờm xuống mặt đứa bé và dụi mớ râu ria lởm chởm của lão lên làng da non của đứa bé. Rồi thình lình lão Hagrid thốt lên một tiếng như tiếng chó bị thương. Giáo sư McGonagall vội nhắc nhở:
- Xuỵt! Lão đánh thức đám Muggle bây giờ.
Lão Hagrid thổn thức:
- Xin lỗi, hic hic. Nhưng tôi không thể… Hic hic. Vợ chồng Potter chết rồi, và Harry bé bỏng phải đi ở nhờ dân Muggle. Hic hic.
Giáo sư McGonagall vỗ về:
- Vâng, vâng, buồn lắm, nhưng mà ráng nín khóc đi, Hagrid, không thôi bọn mình bị lộ đấy.
Lão Hagrid cố dằn cảm xúc, đứng bên giáo sư McGonagall, nhìn theo cụ Dumbledore bồng Harry Potter đi qua sân vườn đến cửa trước nhà Dursley, nhẹ nhàng đặt đứa bé xuống bật cửa, lấy trong áo trùm ra một lá thư, nhét lá thư dưới lớp chăn quấn quanh đứa bé, rồi trở lại với hai người kia. Cả ba đứng lặng cả phút nhìn cái bọc chăn tả đang ấp ủ đứa bé. Vai của Hagrid run lên từng chập, mắt của giáo sư McGonagall chớp chớp liên tục, và cái tia sáng lấp lánh thường loé lên từ đôi mắt của cụ Dumbledore cũng dường như tắt ngóm. Cuối cùng cụ Dumbledore nói:
- Thôi, đành thế. Chúng ta chẳng còn việc gì ở đây nữa. Có lẽ chúng ta đi nhập tiệc với những người khác thôi.
- Dạ. –Tiếng lão Hagrid đáp rõ to. – Tôi sẽ đem trả lại Sirius cái xe này. Chào giáo sư McGonagall, và xin chào ngài, giáo sư Dumbledore.
Chùi nước mắt còn đang chảy ròng ròng trên mặt, lão Hagrid nhảy lên xe và đạp một cái cật lực cho máy nổ, rồi lão rú ga phóng vào không trung đen như hũ nút.
Cụ Dumbledore cuối đầu chào bà McGonagall:
- Tôi mong sớm gặp lại bà, giáo sư McGonagall.
Giáo sư McGonagall hỉ mũi một cái để đáp lễ. Cụ Dumbledore xoay người bước xuống đường. Tới góc đường, cụ dừng bước, lấy trong áo trùm ra cái tắc - lửa bằng bạc. Cụ giơ lên bấm nó một cái, rồi mười hai cái, lập tức mười hai cái bóng đèn trên đường Privet Drive bật sáng, nhưng cũng không kịp soi bóng một con mèo hoang to tướng chuồn lẹ đằng sau khúc quanh ở phía đầu kia con đường.
Còn lại một mình, cụ Dumbledore nhìn lần cuối cái bọc chăn tả trên bậc cửa ngôi nhà số 4. Cụ ngậm ngùi nói:
- Chúc cháu may mắn, Harry.
Rồi phất tấm áo trùm một cái cụ biến mất.
Một luồn gió thoảng qua những hàng rào cây xanh của ngôi nhà trên đường Privet Drive. Ngôi nhà ngăn nắp và những hàng rào cắt xén ngay ngắn ấy là nơi cuối cùng mà người ta có thể mong đợi một chuyện kỳ lạ xảy ra. Harry Potter trở mình trong cuộn chăn mà không thức giấc. Một nắm tay nhỏ xíu của bé đặt trên lá thư sát bên mình, và bé ngủ tiếp, không hề biết là vài tiếng đồng hồ nữa bà Dursley sẽ đánh thức bé dậy bằng một tiếng hét thảng thốt khi bà mở cửa để bỏ những vỏ chai sữa rỗng. Đứa bé cũng không biết là mình sẽ trở thành món đồ chơi của thằng anh họ Dudley, bi nó tha hồ ngắt véo trong vài tuần lễ sau đó. Đứa bé không hề biết gì về những điều đó trong lúc này, cái lúc này mà khắp nơi trên cả nước, tiệc tùng linh đình đang diễn ra, người người đều nâng ly chúc tụng: “Uống mừng Harry Potter! Đứa bé vẫn sống!''';

}
