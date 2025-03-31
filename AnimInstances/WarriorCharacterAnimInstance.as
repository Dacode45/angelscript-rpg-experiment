class UWarriorCharacterAnimInstance : UWarriorBaseAnimInstance
{
	UPROPERTY()
	AWarriorBaseCharacter OwningCharacter;

	UPROPERTY()
	UCharacterMovementComponent OwningMovementComponent;

	UPROPERTY(Category = "AnimData|LocomationData")
	float GroundSpeed;

	UPROPERTY(Category = "AnimData|LocomationData")
	bool bHasAcceleration;

	int calls = 0;

	UFUNCTION(BlueprintOverride)
	void BlueprintInitializeAnimation()
	{
		OwningCharacter = Cast<AWarriorBaseCharacter>(TryGetPawnOwner());
		if (OwningCharacter != nullptr)
		{
			OwningMovementComponent = OwningCharacter.CharacterMovement;
		}
	}

	UFUNCTION(BlueprintOverride, Meta = (BlueprintThreadSafe))
	void BlueprintThreadSafeUpdateAnimation(float DeltaTime)
	{
		if (OwningCharacter == nullptr || OwningMovementComponent == nullptr)
		{
			return;
		}
		calls++;

		GroundSpeed = OwningMovementComponent.Velocity.Size2D();

		bHasAcceleration = OwningMovementComponent.CurrentAcceleration.SizeSquared() > 0.f;
	}
}