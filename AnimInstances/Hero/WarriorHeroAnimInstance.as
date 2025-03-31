class UWarriorHeroAnimInstance : UWarriorCharacterAnimInstance
{
	UPROPERTY(Category = "AnimData|References")
	AWarriorHeroCharacter OwningHeroCharacter;

	UPROPERTY(Category = "AnimData|Locomotion")
	bool bCanEnterRelaxedState;

	UPROPERTY(Category = "AnimData|Locomotion")
	float EnterRelaxedStateThreshold = 0.5f;

	float IdleElapsedTime = 0.f;

	UFUNCTION(BlueprintOverride)
	void BlueprintInitializeAnimation()
	{
		Super::BlueprintInitializeAnimation();
		OwningHeroCharacter = Cast<AWarriorHeroCharacter>(TryGetPawnOwner());
	}

	UFUNCTION(BlueprintOverride, Meta = (BlueprintThreadSafe))
	void BlueprintThreadSafeUpdateAnimation(float DeltaTime)
	{
		Super::BlueprintThreadSafeUpdateAnimation(DeltaTime);

		if (bHasAcceleration)
		{
			bCanEnterRelaxedState = false;
			IdleElapsedTime = 0;
		}
		else
		{
			IdleElapsedTime += DeltaTime;
			bCanEnterRelaxedState = IdleElapsedTime >= EnterRelaxedStateThreshold;
		}
	}
}