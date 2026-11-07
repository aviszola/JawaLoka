import 'package:flutter/widgets.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../presentation/widgets/quiz_path_painter.dart';

/// Supported types of nodes in the JawaLoka learning path.
enum QuizNodeType {
  /// Regular practice/lesson node.
  regular,

  /// Unit evaluation or checkpoint milestone (Node 10, 20, 30, 40).
  milestone,

  /// Grand finale comprehensive evaluation (Node 50).
  finalExam,
}

/// Horizontal visual alignment on the winding learning path.
enum QuizNodePosition {
  /// Shifted to the left side of the path (x ≈ -0.55).
  left,

  /// Centered on the path (x = 0.0).
  center,

  /// Shifted to the right side of the path (x ≈ +0.55).
  right,
}

extension QuizNodePositionExtension on QuizNodePosition {
  /// Relative alignment X value in range `[-1.0, 1.0]`.
  double get alignmentX {
    switch (this) {
      case QuizNodePosition.left:
        return -0.55;
      case QuizNodePosition.center:
        return 0.0;
      case QuizNodePosition.right:
        return 0.55;
    }
  }

  /// Normalized horizontal fraction in range `[0.0, 1.0]`.
  double get fractionX => (alignmentX + 1.0) / 2.0;
}

/// Domain model representing a single step on the 50-node quiz path.
class QuizPathNode {
  /// Canonical activity identifier, e.g. `'path_node_u1_n01_salam'`.
  final String id;

  /// 1-based unit index (1 through 5).
  final int unitId;

  /// Global 1-based order in the entire journey (1 through 50).
  final int nodeNumber;

  /// 1-based index within its unit (1 through 10).
  final int indexInUnit;

  /// Default/fallback title (Indonesian).
  final String defaultTitle;

  /// Public title property.
  String get title => defaultTitle;

  /// Default/fallback description (Indonesian).
  final String description;

  /// Unique semantic topic key for localization and curriculum mapping.
  final String topicKey;

  /// Javanese script glyph displayed inside the node avatar.
  final String glyph;

  /// Classification of the node (regular, milestone, finalExam).
  final QuizNodeType type;

  /// Horizontal position on the winding path.
  final QuizNodePosition position;

  /// Interactive state of the node (completed, current, locked).
  final NodeStatus status;

  const QuizPathNode({
    required this.id,
    required this.unitId,
    required this.nodeNumber,
    required this.indexInUnit,
    required this.defaultTitle,
    required this.description,
    required this.topicKey,
    required this.glyph,
    this.type = QuizNodeType.regular,
    this.position = QuizNodePosition.center,
    this.status = NodeStatus.locked,
  });

  /// Whether this node represents a milestone, evaluation, or badge node.
  bool get isMilestone =>
      type == QuizNodeType.milestone ||
      type == QuizNodeType.finalExam ||
      topicKey == 'lencana';

  /// Whether this node is the grand finale evaluation node.
  bool get isFinalExam => type == QuizNodeType.finalExam;

  /// Returns the localized title of this node using active locale.
  String getLocalizedTitle(BuildContext context) {
    final l10n = context.l10n;
    switch (topicKey) {
      case 'salam':
        return l10n.quizTopicSalam;
      case 'pamit':
        return l10n.quizTopicPamit;
      case 'lencana':
        return l10n.quizTopicLencana;
      case 'tanya_kabar':
        return l10n.quizTopicTanyaKabar;
      case 'perkenalan':
        return l10n.quizTopicPerkenalan;
      case 'keluarga':
        return l10n.quizTopicKeluarga;
      case 'rumah':
        return l10n.quizTopicRumah;
      case 'kerabat':
        return l10n.quizTopicKerabat;
      default:
        return title;
    }
  }

  /// Returns the localized description of this node using active locale.
  String getLocalizedDescription(BuildContext context) {
    final l10n = context.l10n;
    switch (topicKey) {
      case 'salam':
        return l10n.quizTopicSalamDesc;
      case 'pamit':
        return l10n.quizTopicPamitDesc;
      case 'lencana':
        return l10n.quizTopicLencanaDesc;
      case 'tanya_kabar':
        return l10n.quizTopicTanyaKabarDesc;
      case 'perkenalan':
        return l10n.quizTopicPerkenalanDesc;
      case 'keluarga':
        return l10n.quizTopicKeluargaDesc;
      case 'rumah':
        return l10n.quizTopicRumahDesc;
      case 'kerabat':
        return l10n.quizTopicKerabatDesc;
      default:
        return description;
    }
  }

  /// Returns the localized unit title displayed on bottom sheet.
  String getUnitTitle(BuildContext context) {
    return context.l10n.quizUnitTitle(unitId, context.l10n.difficultyMudah);
  }

  /// Creates a copy of this node with updated attributes.
  QuizPathNode copyWith({
    String? defaultTitle,
    NodeStatus? status,
    QuizNodePosition? position,
    QuizNodeType? type,
  }) {
    return QuizPathNode(
      id: id,
      unitId: unitId,
      nodeNumber: nodeNumber,
      indexInUnit: indexInUnit,
      defaultTitle: defaultTitle ?? this.defaultTitle,
      description: description,
      topicKey: topicKey,
      glyph: glyph,
      type: type ?? this.type,
      position: position ?? this.position,
      status: status ?? this.status,
    );
  }
}

/// Domain model representing a learning unit comprising 10 nodes.
class QuizUnitData {
  /// 1-based unit ID (1 through 5).
  final int unitId;

  /// Default title of the unit (Indonesian).
  final String defaultTitle;

  /// Public title property.
  String get title => defaultTitle;

  /// Default subtitle/summary of the unit.
  final String subtitle;

  /// The 10 nodes belonging to this unit.
  final List<QuizPathNode> nodes;

  /// Whether the entire unit is locked.
  final bool isLocked;

  const QuizUnitData({
    required this.unitId,
    required this.defaultTitle,
    required this.subtitle,
    required this.nodes,
    this.isLocked = false,
  });

  /// Total number of nodes in this unit (10).
  int get totalNodes => nodes.length;

  /// Total completed nodes in this unit.
  int get completedCount =>
      nodes.where((n) => n.status == NodeStatus.completed).length;

  /// Ratio of completed nodes `[0.0, 1.0]`.
  double get progressRatio =>
      totalNodes > 0 ? (completedCount / totalNodes).clamp(0.0, 1.0) : 0.0;

  /// Returns localized unit title.
  String getLocalizedTitle(BuildContext context) {
    final l10n = context.l10n;
    if (unitId == 1) {
      return l10n.quizUnit1Title;
    } else if (unitId == 2) {
      return l10n.quizUnit2Title;
    }
    return title;
  }

  /// Returns localized unit subtitle.
  String getLocalizedSubtitle(BuildContext context) {
    final l10n = context.l10n;
    if (unitId == 1) {
      return l10n.quizUnit1Subtitle;
    } else if (unitId == 2) {
      return l10n.quizUnit2Subtitle;
    }
    return subtitle;
  }
}
