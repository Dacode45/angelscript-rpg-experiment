class AWarriorWeaponBase : AActor
{
	UPROPERTY(DefaultComponent, Category = "Weapon")
	UStaticMeshComponent WeaponMesh;

	UPROPERTY(DefaultComponent, Category = "Weapon")
	UBoxComponent WeaponCollisionBox;

	default WeaponCollisionBox.CollisionEnabled = ECollisionEnabled::NoCollision;
}