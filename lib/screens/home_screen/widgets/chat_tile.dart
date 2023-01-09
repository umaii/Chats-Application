part of '../home_screen.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.name,
    required this.img,
    required this.message,
    required this.lastMessage,
  }) : super(key: key);

  final String name;
  final String img;
  final String message;
  final String lastMessage;

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Positioned(
        left: 4,
        right: 2,
        top: 8,
        child: Container(
          height: 80,
          decoration: UIStyles.chatDecoration.copyWith(
            color: ConstColors.lightShadeOrange,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: UIStyles.chatDecoration.copyWith(
          color: ConstColors.white,
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Container(
                height: 40,
                decoration: UIStyles.profileDecorationAvatar,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: ConstColors.darkerCyan,
                  backgroundImage: NetworkImage(img),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyles.style14Bold,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyles.style12,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                lastMessage,
                style: TextStyles.style12,
              ),
              const SizedBox(height: 4),
              const CircleAvatar(radius: 6),
            ],
          )
        ]),
      ),
    ]);
  }
}
