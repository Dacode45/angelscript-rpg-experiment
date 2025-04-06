event void FOnOwningHeroUIComponentInitialized(UHeroUIComponent HeroUIComponent);
event void FOnOwningEnemyUIComponentInitialized(UEnemyUIComponent EnemyUIComponent);

class UWarriorWidgetBase : UUserWidget
{

	UPROPERTY()
	FOnOwningEnemyUIComponentInitialized OnOwningEnemyUIComponentInitialized;

	UPROPERTY()
	FOnOwningHeroUIComponentInitialized OnOwningHeroUIComponentInitialized;

	UFUNCTION(BlueprintCallable)
	void DoCustomInitialize()
	{
		AWarriorBaseCharacter Character = Cast<AWarriorBaseCharacter>(GetOwningPlayerPawn());
		check(Character != nullptr, "Missing Character");

		UHeroUIComponent HeroUIComponent = Character.GetHeroUIComponent();

		if (HeroUIComponent != nullptr)
		{
			OnOwningHeroUIComponentInitialized.Broadcast(HeroUIComponent);
		}
	}

	UFUNCTION()
	void InitEnemyCreatedWidget(AActor OwningEnemyActor) {
		AWarriorBaseCharacter Character = Cast<AWarriorBaseCharacter>(OwningEnemyActor);
		check(Character != nullptr, "Missing Character");

		UEnemyUIComponent EnemyUIComponent = Character.GetEnemyUIComponent();
		check(EnemyUIComponent != nullptr, f"Missing UI Enemy component: {Character.Name}");

		if (EnemyUIComponent != nullptr)
		{
			OnOwningEnemyUIComponentInitialized.Broadcast(EnemyUIComponent);
		}
	}
};