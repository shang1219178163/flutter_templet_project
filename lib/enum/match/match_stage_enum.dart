/// 比赛阶段
enum MatchStageEnum {
  champion(name: 'champion', desc: '冠军', teamCount: 1, teamDesc: "选 1 支夺冠"),
  top2(name: 'top2', desc: '半决赛', teamCount: 2, teamDesc: "选 2 支"),
  top4(name: 'top4', desc: '4强', teamCount: 4, teamDesc: "选 4 支"),
  top8(name: 'top8', desc: '8强', teamCount: 8, teamDesc: "选 8 支"),
  top16(name: 'top16', desc: '16强', teamCount: 16, teamDesc: "选 16 支"),
  top32(name: 'top32', desc: '32强', teamCount: 32, teamDesc: "选 32 支"),
  ;

  const MatchStageEnum({
    required this.name,
    required this.desc,
    required this.teamCount,
    required this.teamDesc,
  });

  final String name;

  final String desc;

  final int teamCount;

  final String teamDesc;
}
