class AWarriorAngelScriptAIController : AWarriorAIController
{
	UPROPERTY(DefaultComponent)
	UAIPerceptionComponent EnemyPerceptionComponent;

	UPROPERTY()
	UAISenseConfig_Sight AISenseConfig_Sight;

	UPROPERTY(Category = "Detour Crowd Avoidance Config")
	bool bEnableDetourCrowdAvoidance = true;

	UPROPERTY(Category = "Detour Crowd Avoidance Config", meta = (EditCondition = "bEnableDetourCrowdAvoidance"))
	float CollisionQualityRange = 600.f;

	default AISenseConfig_Sight = UAISenseConfig_Sight.DefaultObject;

	default AISenseConfig_Sight.DetectionByAffiliation.bDetectEnemies = true;
	default AISenseConfig_Sight.DetectionByAffiliation.bDetectFriendlies = false;
	default AISenseConfig_Sight.DetectionByAffiliation.bDetectNeutrals = false;

	default AISenseConfig_Sight.SightRadius = 5000.f;
	default AISenseConfig_Sight.LoseSightRadius = 0.f;
	default AISenseConfig_Sight.PeripheralVisionAngleDegrees = 360.f;

	default EnemyPerceptionComponent.SensesConfig.Add(AISenseConfig_Sight);
	default EnemyPerceptionComponent.DominantSense = UAISense_Sight::StaticClass();
	default EnemyPerceptionComponent.OnTargetPerceptionUpdated.AddUFunction(this, n"OnEnemyPerceptionUpdated");

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		UCrowdFollowingComponent CrowdFollowingComponent = Cast<UCrowdFollowingComponent>(GetPathFollowingComponent());
		check(CrowdFollowingComponent != nullptr);
	}

	UFUNCTION()
	void OnEnemyPerceptionUpdated(AActor Actor, FAIStimulus Stimulus)
	{
		if (Stimulus.WasSuccessfullySensed())
		{
			check(Blackboard != nullptr, "missing Blackboard");
			Blackboard.SetValueAsObject(n"TargetActor", Actor);
		}
	}
};